
<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="
    java.util.*,
    java.io.*,
    org.apache.sling.api.resource.*,
    com.adobe.granite.ui.clientlibs.script.*"%><%
    
    ScriptCompiler compiler = Arrays.stream(sling.getServices(ScriptCompiler.class, null))
        .filter(script -> script.getName().equals("less"))
        .findFirst().orElse(null);
    
    List<ScriptResource> src = new ArrayList<>();
    // add files listed in css.txt
    src.add(new ScriptResourceImpl(resourceResolver.getResource("/apps/7eleven/clientlibs/clientlib-base/css/all.less")));

    CompilerContext ctx = new CompilerContextImpl(new ScriptResourceProviderImpl(resourceResolver));
    compiler.compile(src, out, ctx);

%><%!

public static class ScriptResourceImpl implements ScriptResource {
  private final Resource resource;

  public ScriptResourceImpl(Resource resource) {
    this.resource = resource;
  }
  
  public String getName() {
    // @imports will be resolved relative to this path
    return resource.getPath();
  }
  
  public long getSize() {
    return -1;
  }
  
  public Reader getReader() throws IOException {
    return new InputStreamReader(resource.adaptTo(InputStream.class), "utf-8");
  }
}

public static class CompilerContextImpl implements CompilerContext {
  private ScriptResourceProvider provider;
  private Collection<String> dependencies;
  
  public CompilerContextImpl(ScriptResourceProvider provider) {
    this.provider = provider;
    this.dependencies = new ArrayList<>();
  }
  
  public ScriptResourceProvider getResourceProvider() {
    return this.provider;
  }
  
  public String getDestinationPath() {
    return null; 
  }
  
  public Collection<String> getDependencies() {
     // Less compiler will add @imports to this collection
    return dependencies;
  }
}

public static class ScriptResourceProviderImpl implements ScriptResourceProvider {
  private ResourceResolver resourceResolver;
  
  public ScriptResourceProviderImpl(ResourceResolver resolver) {
    this.resourceResolver = resolver;
  }
  
  public ScriptResource getResource(String path) throws IOException {
    return new ScriptResourceImpl(resourceResolver.getResource(path));
  }
}


%>
