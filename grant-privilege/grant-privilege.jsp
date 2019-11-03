<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    javax.jcr.*,
    javax.jcr.security.Privilege,
    org.apache.jackrabbit.api.security.user.*,
    org.apache.jackrabbit.commons.jackrabbit.authorization.AccessControlUtils"%><pre>
<%

    // the privileges to grant
    String[] privileges = {"cq:createStuff", "cq:manageStuff"}; 
    // the group to grant the above privileges
    String groupId = "projects-we_retail-editor";
    // the allowed path
    String path = {"/content/we-retail"};

    Session session = resourceResolver.adaptTo(Session.class);
    UserManager userManager = resourceResolver.adaptTo(UserManager.class);

    Privilege[] privs = AccessControlUtils.privilegesFromNames(session, privileges);

    Authorizable authorizable = userManager.getAuthorizable(groupId);
    AccessControlUtils.addAccessControlEntry(session, path, authorizable.getPrincipal(), privs, true);
    out.println("granted " + Arrays.toString(privileges) + " to " + groupId + " on " + path);

%></pre>


