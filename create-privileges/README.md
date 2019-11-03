# AEM Fiddle Scripts

Create custom privileges in a Oak repository.

The built-in and custom privileges are stored in the repository under /jcr:system/rep:privileges.
The nodes storing the privileges are protected by their node type definition
and cannot be modified using the JCR API. Jackrabbit Oak provides PrivilegeManager, 
an extension to retrieve or register custom privileges according to the implementation needs.

Once created, custom privileges are no different from the built-in ones and can be managed from CRXDE 
or scripting tools like [Netcentric AC Tool](https://github.com/Netcentric/accesscontroltool)

This script must run from an administrative account.

