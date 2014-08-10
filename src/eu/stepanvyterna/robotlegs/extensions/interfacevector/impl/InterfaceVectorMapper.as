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

package eu.stepanvyterna.robotlegs.extensions.interfacevector.impl
{
	
	import eu.stepanvyterna.robotlegs.extensions.interfacevector.api.IInterfaceVectorMapper;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.swiftsuspenders.InjectionEvent;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.framework.api.IInjector;
	
	public class InterfaceVectorMapper implements IInterfaceVectorMapper
	{
		
		static private const VECTOR_CLASS_NAME:String = getQualifiedClassName(Vector);
		
		private var _injector:IInjector;
		private var processing:Boolean = false;
		
		private var registeredInstances:Dictionary = new Dictionary();
		private var registeredBehaviors:Vector.<Class> = new Vector.<Class>();
		private var blacklistFilter:ITypeFilter;
		private var blacklistedInterfaces:Vector.<Class> = new Vector.<Class>();
		
		public function InterfaceVectorMapper(injector:IInjector)
		{
			_injector = injector;
		}
		
		private function onPostInstantiate(e:InjectionEvent):void
		{
			if (blacklistFilter && blacklistFilter.matches(e.instance))
			{
				return;
			}
			const instance:* = e.instance;
			for each (var clazz:Class in registeredBehaviors)
			{
				if (instance is clazz)
				{
					registeredInstances[clazz].push(instance);
				}
			}
		}
		
		public function registerInterface(interfaceClass:Class):void
		{
			registeredBehaviors.push(interfaceClass);
			var vectorClass:Class = getDefinitionByName(VECTOR_CLASS_NAME + ".<" + getQualifiedClassName(interfaceClass) + ">") as Class;
			var vector:* = new vectorClass();
			registeredInstances[interfaceClass] = vector;
			_injector.map(vectorClass).toValue(vector);
		}
		
		public function startProcessing():void
		{
			if (!processing)
			{
				processing = true;
				_injector.addEventListener(InjectionEvent.POST_INSTANTIATE, onPostInstantiate);
			}
		}
		
		public function stopProcessing():void
		{
			if (processing)
			{
				processing = false;
				_injector.removeEventListener(InjectionEvent.POST_INSTANTIATE, onPostInstantiate);
			}
		}
		
		public function clear():void
		{
			registeredBehaviors = null;
			registeredInstances = null;
		}
		
		public function addInterfaceToBlacklist(interfaceClass:Class):void
		{
			blacklistedInterfaces.push(interfaceClass);
			updateBlacklistFilter();
		}
		
		public function removeInterfaceFromBlacklist(interfaceClass:Class):void
		{
			var index:int = blacklistedInterfaces.indexOf(interfaceClass);
			if (index > -1)
			{
				blacklistedInterfaces.splice(index, 1);
				updateBlacklistFilter();
			}
		}
		
		private function updateBlacklistFilter():void 
		{
			blacklistFilter = new TypeMatcher().anyOf(blacklistedInterfaces).createTypeFilter();
		}
	
	}

}