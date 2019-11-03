<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    javax.jcr.*,
    org.apache.jackrabbit.api.security.authorization.PrivilegeManager,
    org.apache.jackrabbit.api.JackrabbitWorkspace"%><pre>
<%
    String[] privileges = {"cq:createStuff", "cq:manageStuff"};

    Session session = resourceResolver.adaptTo(Session.class);
    PrivilegeManager privilegeManager = ((JackrabbitWorkspace)session.getWorkspace()).getPrivilegeManager();
    for(String privilegeName : privileges){
        try {
            privilegeManager.registerPrivilege(privilegeName, false, new String[0]);
            out.println("created " + privilegeName);
        } catch(Exception e){
            String alreadyExistsMsg = "Privilege definition with name '" + privilegeName+ "' already exists.";
            if(alreadyExistsMsg.equals(e.getMessage())){
                out.println(alreadyExistsMsg);
            } else {
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        }
    }

%></pre>

