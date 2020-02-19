<%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" contentType="text/html; charset=utf-8" 
	pageEncoding="UTF-8"
    import="
    java.util.*,
    org.osgi.framework.Constants,
    org.osgi.service.cm.ConfigurationAdmin,
    org.osgi.service.cm.Configuration,
    java.util.stream.Collectors"%><%

    // de-dupe a particular factoryPid. Deafault is to de-dupe all factory configurations 
    String pid = "*" ; // com.day.cq.polling.importer.impl.ManagedPollConfigImpl
    // Dry-run    
    boolean dryRun = true; // setting it to false will update the OSGi configurations

    String filter = "(service.factoryPid=" + pid + ")";

    ConfigurationAdmin configAdmin = sling.getService(ConfigurationAdmin.class);

    // get all known factory configurations and group them by FactoryPid
    Configuration[] configurations = configAdmin.listConfigurations(filter);
    Map<String, List<Configuration>> map =
            Arrays.stream(configurations)
                    .collect(Collectors.groupingBy(cfg -> cfg.getFactoryPid()));
                    
    int count = 0;                
    for(String  factoryPid : map.keySet()){
        // within each group find duplicate configurations
        // a duplicate is a configuration with the same properties ignoring auto properties such as service.pid
        List<Configuration> configs = map.get(factoryPid);
        Map<Integer, List<Configuration>> byHash = configs.stream()
                .collect(Collectors.groupingBy(cfg -> toString(cfg.getProperties()).hashCode()));
         for(List<Configuration> lst : byHash.values()) {

            if(lst.size() > 1) { // duplicates detected
                out.println("Found " + lst.size() + " identical configurations for " + factoryPid);
                boolean first = true;        
                for(int i = 1; i <= lst.size(); i++){
                    Configuration cfg = lst.get(i-1);
                    if(!first) {
                        out.println(i + "\tdeleting " + cfg.getPid());
                        if(!dryRun) cfg.delete();
                    } else {
                        out.println("Configuration: " + toString(cfg.getProperties()));
                        out.println(i + "\tretaining " + cfg.getPid());
                    }
                    first = false;
                }
                count++;
            }
        }
    }
    out.println("All done. " + count + " factoryPids with dulicated configurations updated");

%><%!
    public String toString(Dictionary<String, Object> dict) {
        StringBuilder sb = new StringBuilder();
        sb.append('{');
        Enumeration<String> keys = dict.keys();
        while ( keys.hasMoreElements() ) {
            String key = keys.nextElement();
            if ( !isAutoProp(key) ) {
                Object value = dict.get(key);

                if (sb.length() > 0) sb.append(", ");
                sb.append(key);
                sb.append('=');
                if (value.getClass().isArray()) {
                    sb.append(Arrays.toString((Object[]) value));
                } else {
                    sb.append(value.toString());
                }
            }
        }
        sb.append('}');
        return sb.toString();
    }

    public static final  List<String> AUTO_PROPS = Arrays.asList(
            Constants.SERVICE_PID,
            ConfigurationAdmin.SERVICE_FACTORYPID,
            ConfigurationAdmin.SERVICE_BUNDLELOCATION
    );

    boolean isAutoProp(String name)
    {
        return AUTO_PROPS.contains(name);
    }
%>




