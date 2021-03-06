# AEM Fiddle Scripts

## Programmatically Updating Crypto Keys in AEM

To read data on one instance that was secured on another, all of your AEM instances need to have the same encryption keys. Prior to AEM 6.3, you would package up /etc/key and share it between your servers. However, in AEM 6.3 the Crypto keys were moved out of the JCR to make them more secure in case someone gains access to your CRXDE. 

The approach recommended by Adobe is to replicate the crypto keys as a part of AEM Setup :

1. Find ID of the _com.adobe.granite.crypto.file_, e.g. 21. You can navigate to /system/console/bundles/com.adobe.granite.crypto.file to see the Id.
2. Navigate to /crx-quickstart/launchpad/felix/bundle<Id>/data in the file system.
3. Copy  the hmac and master files to /crx-quickstart/launchpad/felix/bundle<Id>/data .
4. Restart the com.adobe.granite.crypto bundle or the entire AEM instance.

What if you don't have ssh access to the AEM instances ? This  [script](encyptionKeys.jsp)  demonstrates an approach how to update the Crypto keys programmatically. 

### 1. Upload the key to update in AEM
for example, in _/etc/key/hmac_

### 2. Read the key bytes
```java
byte[] key = IOUtils.toByteArray(hmacResource.getValueMap().get(JcrConstants.JCR_DATA, InputStream.class));
```

### 3. Get the _com.adobe.granite.crypto.file_ bundle
```java
Bundle bundle = Arrays.stream(bundleContext.getBundles())
    .filter(b -> b.getSymbolicName().equals("com.adobe.granite.crypto.file"))
    .findFirst().orElse(null);
```
### 4. Get the 'hmac' file  
```java
File hmacFile = bundle.getDataFile("hmac");
```

### 5. Replace the key
```
OutputStream out = new FileOutputStream(hmacFile);
out.write(key);
out.close();
```

### 6. Refresh the Granite Crypto Bundle
- Navigate to http://\<server\>:\<port\>/system/console/bundles
- Locate Adobe Granite Crypto Support bundle (com.adobe.granite.crypto)
- Click Refresh

### 7. Delete the _hmac_ and _master_ keys. You no longer need them.


# All steps above in a shell snippet
```
# upload the crypto keys 
curl -u admn:admin -Fhmac=@./hmac http://localhost:4502/etc/key
curl -u admn:admin -Fmaster=@./master http://localhost:4502/etc/key

# update the keys
curl -u admn:admin http://localhost:4502/etc/acs-tools/aem-fiddle/_jcr_content.run.html -F scriptdata=@encyptionKeys.jsp -F scriptext=jsp 

# delete the crypto keys
curl  -u admn:admin -F":operation=delete" http://localhost:4502/etc/key/hmac
curl  -u admn:admin  -F":operation=delete" http://localhost:4502/etc/key/hmac

# refresh com.adobe.granite.crypto bundle
curl -u  admn:admin -F action=refresh http://localhost:4502/system/console/bundles/com.adobe.granite.crypto
```

