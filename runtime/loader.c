#include "loader.h"

const uint32_t objc_abi_current_version = 0;
const uint32_t objc_abi_current_compatible_version = 0;


static objc_load_selectors(struct objc_selector_table *selectors)
{
	for (unsigned i=0 ; i<selectors->count ; i++)
	{
		selectors->selector[i] = 
			register_typed_selector(selectors->name[i], selectors->types[i]);
	}
}

static objc_load_classes(struct objc_defined_classes *classes)
{
	for (unsigned i=0 ; i<classes->count ; i++)
	{
		struct objc_uninitialised_class *class = classes->classes[i]->class;
		Class initialised = (Class)class;
		Class super = objc_class_for_name(class->super_class_name);
		if (Nil == super)
		{
			// TODO: Add to list for later initialisation
			continue;
		}
		init_tags((id)initialised);
		initialised->superclass = super;
		for (unsigned j=0 ; j<classes->instance_method_count ; j++)
		{
			objc_install_instance_method(initialised, 
					classes->methods[i]->selector,
					classes->methods[i]->method);
		}
		for (unsigned j=classes->instance_method_count ;
			j<classes->class_method_count; j++)
		{
			objc_install_class_method(initialised, 
					classes->methods[i]->selector,
					classes->methods[i]->method);
		}
	}
}

objc_load_module(struct objc_module *module)
{
	if (module->abi_version < objc_abi_current_compatible_version
		||
		module->abi_version > objc_abi_current_version)
	{
		fprintf(stderr, "Attempting to load module with incompatible ABI\n");
		// FIXME: Add a hook to allow graceful recovery
		abort();
	}
	objc_load_selectors(module->selectors);
	objc_load_classes(module->classes);
}
