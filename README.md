InterfaceVectorExtension
========================

Simple extension for robotlegs to enable injection of vectors of interfaces

For now usable only for singletons

Known issues:
-------------
- No removing of instances
- Performance can be really slow - it's recommended to use stopProcessing() call to disable the extension when all classes have been instantiated
