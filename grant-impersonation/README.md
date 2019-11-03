# AEM Fiddle Scripts

Grant impersonation.

By default only the 'admin' user can impersonate other users. 
This could be annoying because even members of the 'Administrators' group cannot impersonate OOB, 
each impersonation needs to be explicitly granted in the User Security console (http://localhost:4502/useradmin) 

This script programmatically grants impersonation to the given authorizableId.

