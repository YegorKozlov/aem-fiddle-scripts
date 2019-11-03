<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="org.apache.sling.api.resource.*,
    java.util.*,
    javax.jcr.*,
    org.apache.jackrabbit.api.security.user.*,
    java.security.Principal,
    com.day.cq.security.util.CqActions,
    org.apache.jackrabbit.api.JackrabbitSession,
    org.apache.jackrabbit.api.security.principal.PrincipalIterator"%><pre>
<%

    String authId = "ksaner"; // from the We.Retail distro
    String pathFilter = "/content"; // only show permissions under this path

    Set<Principal> principals = new LinkedHashSet();
    Session session = resourceResolver.adaptTo(Session.class);
    CqActions cqActions = new CqActions(session);

    UserManager userManager = resourceResolver.adaptTo(UserManager.class);
    Authorizable auth = userManager.getAuthorizable(authId);
    if(auth == null){
        out.println("Authorizable not found: " + authId);
        return;
    }
    principals.add(auth.getPrincipal());

    out.println("Authorizable: " + authId);
    out.println("Member Of: ");
    for(Iterator<Group> it = auth.memberOf(); it.hasNext();){
        Principal p = it.next().getPrincipal();
        principals.add(p);
        out.println(p.getName());
    }

    Collection<String> paths = new LinkedHashSet<>();
    paths.add(pathFilter);
    for(Principal p : principals) {
        String sql =
                "SELECT a.* FROM [nt:base] AS a\n" +
                        "INNER JOIN [rep:ACL] AS b ON ISCHILDNODE(b,a)\n" +
                        "INNER JOIN [rep:ACE] AS c ON ISCHILDNODE(c,b)\n" + // rep:ACE will match both rep:AllowACE and rep:DenyACE
                        "WHERE c.[rep:principalName]='"+p.getName()+"' \n" +
                        "AND ISDESCENDANTNODE(a, ["+pathFilter+"])\n" +
                        "order by a.[jcr:path]";
        resourceResolver.findResources(sql, "JCR-SQL2").forEachRemaining(res -> paths.add(res.getPath()));
    }
    out.println();

    for(String path : paths){
        List<String> allowed = new ArrayList<>(cqActions.getAllowedActions(path, principals));
        out.println(path + "\t" + allowed);
    }

%></pre>

