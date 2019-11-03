<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    javax.jcr.*,
    org.apache.jackrabbit.api.security.user.*"%><pre><%

    // The principal that should be allowed to impersonate other users.
    // All userIds are from the We.Retail distro
    String impersonator = "ksaner";

    // The users to impersonate
    String[] users = {
            "cavery",
            "imccoy"
            
    };

    UserManager userManager = resourceResolver.adaptTo(UserManager.class);
    User user = (User)userManager.getAuthorizable(impersonator); // from the We.Retail distro
    for(String userId : users) {
        User authorizable = (User)userManager.getAuthorizable(userId);
        if(authorizable == null) {
          out.println("user not found: " + userId);
        } else {
          out.println("granted " + impersonator + " impersonation of " + userId);
          authorizable.getImpersonation().grantImpersonation(user.getPrincipal());
        }
    }

%></pre>
