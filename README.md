InterfaceVectorExtension
========================

Simple extension for robotlegs to enable injection of vectors of interfaces

For now usable only for singletons

Known issues:
-------------
- No removing of instances
- Performance can be really slow - it's recommended to use stopProcessing() call to disable the extension when all classes have been instantiated

Usage:
------
- Main class (where context is initialized)
```actionscript
context.install(MVCSBundle)
				.install(InterfaceVectorExtension); //Instal the extension
```

- Config file
```actionscript

		[Inject]
		public var interfaceMapper:IInterfaceVectorMapper;
		
		public function configure():void 
		{
			
			interfaceMapper.registerInterface(IOne);
			interfaceMapper.registerInterface(ITwo);
			interfaceMapper.registerInterface(IThree);
			
			// Do your mappings
		}
```

- Injection
```actionscript

		[Inject]
		public var ones:Vector.<IOne>; // Inject all instances at once by their interface
		
```
