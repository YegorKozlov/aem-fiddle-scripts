# AEM Fiddle Scripts

## De-Duplicate OSGi Configurations
A script to find and de-duplicate OSGi Factory configurations.

This is to address some scenarios with AEM and Apache Sling installations where factory configs get duplicated. See [SLING-6313](https://jira.apache.org/jira/browse/SLING-6313) for the explanation of the problem.
There is a [felix-osgi-config-repair](https://github.com/cqsupport/felix-osgi-utils/tree/master/felix-osgi-config-repair) tool by Andrew Khoury to address this problem, but this tool is a runnable jar which you need to upload and execute on a running Sling instance. In many cases it is difficult to do, for example, when AEM is running in a immutable container in AWS EC2. This script is a online version of [felix-osgi-config-repair](https://github.com/cqsupport/felix-osgi-utils/tree/master/felix-osgi-config-repair) which can run from AEM Fiddle.


### Usage
By default the script lists the found duplicates: 

```
Found 5 identical configurations for org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended
Configuration: {service.ranking=0, user.mapping=[com.adobe.cq.social.cq-social-tally:ugc-writer=communities-ugc-writer]}
1	retaining org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.78e7c8bd-635d-4a52-8c7d-d7085dc4a2c8
2	deleting org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.4875ca88-666f-4589-a51c-20a09fa13b19
3	deleting org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.f5806989-c89d-41aa-abc2-22c9062233de
4	deleting org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.6f0453c1-3afc-4425-999e-7281ef5d89be
5	deleting org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.ec460cd5-62b8-4d13-b9b8-6752aaa56599
Found 5 identical configurations for org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended
Configuration: {user.default=, user.mapping=[com.adobe.cq.smartcontent-core:nlp-reader=nlp-reader]}
1	retaining org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.c9ac0c38-01ae-440b-b29b-1ab256727b0c
2	deleting org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.1504fd47-f1f8-4df4-883e-d553b7654200
3	deleting org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.2dfc5b82-81a8-4b63-bdb3-a6f7c1bb29a6
4	deleting org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.74f23b46-fadb-4629-b76b-3205c9733ab2
5	deleting org.apache.sling.serviceusermapping.impl.ServiceUserMapperImpl.amended.5f5cd2fb-20ec-447b-a211-922299f98189
...
```

To delete duplicate configurations set the dryRun flag to false:
```
    // de-dupe a particular factoryPid. Deafault is to de-dupe all factory configurations 
    String pid = "*" ; // com.day.cq.polling.importer.impl.ManagedPollConfigImpl
    // Dry-run    
    boolean dryRun = true; // setting it to false will update the OSGi configurations
```
You can optionally narrow down the scope of the update to a particular factoryPid. 

