
/**
 * The selectors used in this compilation unit.  This uses parallel arrays for
 * more efficient cache usage.  The name and types arrays are not used after
 * the loader is 
 */
struct objc_selector_table
{
	/**
	 * The number of selectors.
	 */
	uint32_t count;
	/**
	 * A pointer to an array of selector names.
	 */
	const char **name;
	/**
	 * A pointer to an array of selector types.
	 */
	const char **types;
	/**
	 * A pointer to an array of selectors.
	 */
	SEL *selector;
};

struct objc_method_list
{
	uint32_t instance_method_count;
	uint32_t class_method_count;
	struct
	{
		SEL selector;
		IMP method;
	} mehods;
};
/**
 * An uninitialised class structure.  This must have the same size as an
 * objc_class, but contains fields that will be replaced with their run-time
 * equivalent versions during initialisation.
 */
struct objc_uninitialised_class 
{
	/** The name of the superclass */
	const char *super_class_name;
	/** The list of class methods */
	struct objc_method_list *methods;
	/** The name of the class */
	const char * name;
	/** The number of instance variables. */
	uint32_t ivar_count;
	/** 
	 * Array of instance variable metadata.  The offset field should be
	 * initialised by the compiler to the offset from the start of the instance
	 * variables defined by this class
	 */
	struct ivar_list *ivars;
	/** Array of protocols implemented by this class. */
	struct protocol_list *protocols;
	/** 
	 * The size of an instance.  Should be initialised to the size of the
	 * instance variables declared by this class 
	 */
	uint32_t instance_size;
};
/**
 * Padding to ensure that there is enough space to initialise all of the tags
 * associated with an object.
 */
static const uint32_t PREOBJECT_PADDING = 64;

struct objc_defined_classes
{
	/** Number of classes in this module. */
	uint32_t count;
	/** Array of uninitialised classes. */
	struct
	{
		unsigned char padding[PREOBJECT_PADDING];
		struct objc_uninitialised_class class;
	} classes[1];
};

/**
 * The ABI version of the current library.  This must be incremented every time
 * anything is added to the ABI.
 */
extern const uint32_t objc_abi_current_version;
/**
 * The lowest compatible ABI version.  This must be increased every time the
 * ABI is modified in such a way that breaks backward compatibility.
 */
extern const uint32_t objc_abi_current_compatible_version;

struct objc_module;
{
	/** The version of the ABI for which this module was compiled. */
	uint32_t abi_version;
	/** The name of this module. */
	const char *name;
	/** The selectors used by this module. */
	struct objc_selector_table *selectors;
	/** The classes defined in this module. */
	struct objc_defined_classes *classes;
	struct objc_defined_categories *categories;
};
