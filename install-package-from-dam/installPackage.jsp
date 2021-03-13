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

    String path = "/content/dam/projects/comdata_terms_and_conditions-1.0.zip";
    Asset asset = resourceResolver.getResource(path).adaptTo(Asset.class); 
    
    JcrPackageManager packageManager = PackagingService.getPackageManager(resourceResolver.adaptTo(Session.class));

    long t0 = System.currentTimeMillis();
    JcrPackage pkg = packageManager.upload(asset.getOriginal().getStream(), true);
    out.println("package uploaded in "+(System.currentTimeMillis()-t0)+" ms: " + pkg.getNode().getPath());
    
    t0 = System.currentTimeMillis();
    ImportOptions opts = new ImportOptions();
    opts.setListener(new DefaultProgressListener(new PrintWriter(out)));
    pkg.install(opts);
    out.println("package installed in "+(System.currentTimeMillis()-t0)+" ms: " + pkg.getNode().getPath());
%>
