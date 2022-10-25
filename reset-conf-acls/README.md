# reset permissions

A typical problem is when you package the `/conf` folder, replicate it and your sites stop working becasue the replicated `/conf` contains author ACLs whereas publish instances need anonymous access.
The script below grants `jcr:read` to `everyone` to /conf sub-folders.

```
<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    javax.jcr.*,
    org.apache.jackrabbit.commons.jackrabbit.authorization.AccessControlUtils"%><%

    Session jcrSession = resourceResolver.adaptTo(Session.class);
    
    for(Resource res : resourceResolver.getResource("/conf").getChildren()){
        if(res.getChild("settings") == null){
            continue;
        }
        String path = res.getPath();
        AccessControlUtils.clear(jcrSession, path);
        AccessControlUtils.allow(jcrSession.getNode(path), "everyone", "jcr:read");
        out.println(path);
    }
    resourceResolver.commit();
%>
```
