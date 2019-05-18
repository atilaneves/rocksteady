/**
   Descriptions of build systems.
 */
module rocksteady.systems;


/**
   The busy build system.

   Params:
       tasks = Takes a key and returns a Nullable!Task.
       key = The key to compute the value of.
       store = The backing store to affect.
 */
auto busy(alias tasks, S)(ref S store)
    @safe pure  // FIXME: why is this not being inferred?
{
    struct Build {

        import rocksteady.traits: KeyType, ValueType;

        ValueType!S build(in KeyType!S key) @safe pure const {

            auto maybeTask = tasks(key, &build /* build is fetch */);
            if(maybeTask.isNull) return store[key];

            auto task = maybeTask.get;
            auto newValue = task();
            store[key] = newValue;

            return newValue;
        }
    }

    return Build();
}
