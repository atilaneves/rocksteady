/**
   Descriptions of build systems.
 */
module rocksteady.systems;


/**
   The busy build system.

   Params:
       tasks = Takes a key and returns a Nullable!Task.
       store = The backing store to affect.
 */
auto busy(alias tasks, S)(ref S store)
    @safe pure  // FIXME: why is this not being inferred?
{
    struct Build {

        import rocksteady.traits: KeyType, ValueType;

        ValueType!S build(in KeyType!S key) @safe pure const {

            auto maybeTask = tasks(this, key);
            // it's a leaf node aka input key, just return it
            if(maybeTask.isNull) return store[key];

            // it's an actual task, run it and store the new value
            auto task = maybeTask.get;
            auto newValue = task();
            store[key] = newValue;

            return newValue;
        }

        alias fetch = build;
    }

    return Build();
}
