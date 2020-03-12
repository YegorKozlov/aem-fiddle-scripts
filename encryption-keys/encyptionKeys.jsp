<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    java.io.*,
    java.nio.file.*,
    org.osgi.framework.*,
    org.apache.commons.io.IOUtils,
    org.apache.jackrabbit.JcrConstants"%>
<%

    String hmacPath = "/etc/key/hmac";
    String masterPath = "/etc/key/master";
    BundleContext bc = FrameworkUtil.getBundle(Resource.class).getBundleContext();

    String symbolicName = "com.adobe.granite.crypto.file";    
    Bundle bnd = Arrays
        .stream(bc.getBundles())
        .filter(b -> b.getSymbolicName().equals(symbolicName))
        .findFirst().orElse(null);

   
    boolean updated = false;
    updated &= updateKey(masterPath, "master", bnd, resourceResolver, out);
    updated &= updateKey(hmacPath, "hmac", bnd, resourceResolver, out);

    if(updated) {
      out.println("The keys were updated. Please restart the OSGi framework from http://localhost:4502/system/console/vmstat");
    } else {
      out.println("The keys were not modified");
    }
%><%!
  
    boolean updateKey(String path, String name, Bundle bundle, ResourceResolver resourceResolver, JspWriter out) throws Exception {
        boolean updated = false;
        File file = bundle.getDataFile(name);
        Resource resource = resourceResolver.getResource(path + "/jcr:content");
        if(resource == null) {
            out.println("not found: " + path);
            return false;
        }
        try (InputStream is = resource.getValueMap().get(JcrConstants.JCR_DATA, InputStream.class)) {
            byte[] currentKey = IOUtils.toByteArray(file.toURI().toURL());
            byte[] newKey = IOUtils.toByteArray(is);
            if(!Arrays.equals(currentKey, newKey)){
                out.println("backing up  " + file);
                Files.copy(file.toPath(), Paths.get(file.getPath() + ".bak"), StandardCopyOption.REPLACE_EXISTING);
                out.println("updating " + file);
                try(OutputStream os = new FileOutputStream(file)){
                    os.write(newKey);
                }
                updated = true;
            } else {
                out.println(name + " key is the same. skipping ");
            }
        }
        return updated;
    }

%>

