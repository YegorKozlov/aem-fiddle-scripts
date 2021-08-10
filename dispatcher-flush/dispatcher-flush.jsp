
<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    javax.jcr.*,
    org.apache.http.impl.client.*,
    org.apache.http.*,
    org.apache.http.client.methods.HttpPost,
    org.apache.http.client.methods.CloseableHttpResponse,
    org.apache.http.message.BasicNameValuePair"%><%

    String[] hosts = {"http://127.0.0.1"};
    String[] paths = {"/content", "/etc.clientlibs"};
    // Code here
    try(CloseableHttpClient hc = HttpClients.custom().build()) {
        out.println("OK");
        
        for(String host : hosts){
            String uri = host + "/dispatcher/invalidate.cache";
            HttpPost req = new HttpPost(uri);
            out.println("Flushing " + req.getURI());
            req.addHeader("Host", "flush");
            for(String path : paths){
                req.addHeader("CQ-Handle", path);
            }
            req.addHeader("CQ-Action", "Delete");

            try (CloseableHttpResponse resp = hc.execute(req)) {
                int statusCode = resp.getStatusLine().getStatusCode();
                out.println(statusCode);
    
            } catch (Exception e){
                e.printStackTrace(response.getWriter());
            }
            
        }
        
     }
%>
