# Install Package From DAM

There can be situations when you need to install a JCR package but you don't have access to the CRX Package Manager (http://localhost:4502/crx/packmgr/index.jsp)

AEM Fiddle comes to rescue. The idea is to upload your package in DAM and then programmatically upload and install it.

```java
<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    java.io.PrintWriter,
    javax.jcr.*,
    org.apache.jackrabbit.vault.packaging.*,
    org.apache.jackrabbit.vault.fs.io.ImportOptions,
    org.apache.jackrabbit.vault.util.DefaultProgressListener,
    com.day.cq.dam.api.Asset"%><%

    // the package uploaded in DAM
    String path = "/content/dam/projects/terms_and_conditions-1.0.zip";
    Asset asset = resourceResolver.getResource(path).adaptTo(Asset.class); 
    
    JcrPackageManager packageManager = PackagingService.getPackageManager(resourceResolver.adaptTo(Session.class));

    // call JcrPackageManager#upload( InputStream in, boolean replace) to upload the package to the /etc/packages
    long t0 = System.currentTimeMillis();
    JcrPackage pkg = packageManager.upload(asset.getOriginal().getStream(), true);
    out.println("package uploaded in "+(System.currentTimeMillis()-t0)+" ms: " + pkg.getNode().getPath());
    
    // call JcrPackage#install( ImportOptions options) to install the package. Pass a tracking listener to track progress and errors
    t0 = System.currentTimeMillis();
    ImportOptions opts = new ImportOptions();
    opts.setListener(new DefaultProgressListener(new PrintWriter(out)));
    pkg.install(opts);
    out.println("package installed in "+(System.currentTimeMillis()-t0)+" ms: " + pkg.getNode().getPath());
%>
```


