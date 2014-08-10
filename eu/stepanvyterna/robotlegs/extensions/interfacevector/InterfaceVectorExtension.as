/**
 * Copyright (c) 2014 Stepan Vyterna
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
 
package eu.stepanvyterna.robotlegs.extensions.interfacevector
{
	
	import eu.stepanvyterna.robotlegs.extensions.interfacevector.api.IInterfaceVectorMapper;
	import eu.stepanvyterna.robotlegs.extensions.interfacevector.impl.InterfaceVectorMapper;
	import org.swiftsuspenders.InjectionEvent;
	import org.swiftsuspenders.mapping.MappingEvent;
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IGuard;
	import robotlegs.bender.framework.api.IHook;
	import robotlegs.bender.framework.api.IInjector;
	
	
	public class InterfaceVectorExtension implements IExtension
	{
		private var injector:IInjector;
		private var registry:IInterfaceVectorMapper;
		
		public function extend(context:IContext):void 
		{
			injector = context.injector;
			context.beforeDestroying(stopProcessing);
			context.afterInitializing(startProcessing);
			
			registry = new InterfaceVectorMapper(injector);
			injector.map(IInterfaceVectorMapper).toValue(registry);
			
			initializeRegistryBlacklist();
		}
		
		private function initializeRegistryBlacklist():void 
		{
			registry.addInterfaceToBlacklist(ICommand);
			registry.addInterfaceToBlacklist(IGuard);
			registry.addInterfaceToBlacklist(IHook);
			registry.addInterfaceToBlacklist(IConfig);
		}
		
		private function startProcessing():void 
		{
			registry.startProcessing();
		}
		
		private function stopProcessing():void 
		{
			registry.stopProcessing();
			registry.clear();
		}
		
	}

}