/**
*  Programmatically Update Crypto Keys in AEM
*/
<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    java.io.*,
    java.nio.file.*,
    org.osgi.framework.*,
    org.apache.commons.io.IOUtils,
    com.adobe.granite.crypto.spi.*,
    com.day.cq.dam.api.Asset"%><%

    String hmacPath = "/content/dam/crypto/hmac";
    String masterPath = "/content/dam/crypto/master";

    BundleContext bc = FrameworkUtil.getBundle(Resource.class).getBundleContext();

    String symbolicName = "com.adobe.granite.crypto.file";    
    Bundle bnd = Arrays
        .stream(bc.getBundles())
        .filter(b -> b.getSymbolicName().equals(symbolicName))
        .findFirst().orElse(null);

   
    updateKey(masterPath, "master", bnd, resourceResolver, out);
    updateKey(hmacPath, "hmac", bnd, resourceResolver, out);

    out.println("The keys were updated. Please restart the OSGi framework from http://localhost:4502/system/console/vmstat");
    out.println("Don't forget to delete " + hmacPath + " and " + masterPath);

%><%!
  
    void updateKey(String path, String name, Bundle bundle, ResourceResolver resourceResolver, JspWriter out) throws Exception {
        File file = bundle.getDataFile(name);
        Resource resource = resourceResolver.getResource(path);
        if(resource == null) {
            out.println("not found: " + path);
            return;
        }
        try (InputStream is = resource.adaptTo(Asset.class).getOriginal().getStream()) {
            byte[] currentKey = IOUtils.toByteArray(file.toURI().toURL());
            byte[] newKey = IOUtils.toByteArray(is);
            if(!Arrays.equals(currentKey, newKey)){
                out.println("backing up  " + file);
                Files.copy(file.toPath(), Paths.get(file.getPath() + ".bak"), StandardCopyOption.REPLACE_EXISTING);
                out.println("updating " + file);
                try(OutputStream os = new FileOutputStream(file)){
                    os.write(newKey);
                }
            } else {
                out.println(name + " key is the same. skipping ");
            }
        }
    }

%>


