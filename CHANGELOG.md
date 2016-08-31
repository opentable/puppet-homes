##2016-08-31 - Release 2.0.0
###Summary

Focused on fixing the module to work with future parser.

####Features

- Support future parser.
- Modified format of user parameter, username is the resource title and not the key from the user hash.

####Bugfixes

- Fix module to accept groups as array as per documentation.

##2014-10-10 - Release 1.0.0
###Summary

This release is focused on bring the module up to a recognized standard.
It it mainly focused on documentation and testing.

####Features

- Improved documentation
- Added support for Amazon Linux

####Bugfixes

- Fixed tests in newer versions of puppet

##2014-06-17 - Release 0.3.1
###Summary

This release fixing some minor bugs where to module does not clean up after itself

####Bugfixes

 - fixed bug with ensure=>absent not cleanly removing all resources

##2014-05-13 - Release 0.3.0
###Summary

This release focused on adding some addtional key types

####Features

 - support for additional key types (#3)
 - support for managing ~/.ssh/config file

##2014-04-07 - Release 0.2.1
###Summary

Small bug fix release to update the altlib dependency

##2014-03-21 - Release 0.2.0
###Summary

This release focuses mainly on adding support for dsa keys and fixing some cross-plaform issues

####Features

- adding support for dsa keys
- adding tests with beaker
- improved the documentation

####Bugfixes

- fixed issue with sudo/wheel groups being applied on different operating systems

##2014-03-06 - Release 0.1.0
###Summary

 Initial release. Basic support for managing home directory and public ssh keys
