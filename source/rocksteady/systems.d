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
{
    struct Build {

        import rocksteady.traits: KeyType, ValueType;

        ValueType!S build(in KeyType!S key) @safe pure const {

            import rocksteady.types: Leaf;
            import sumtype: match;

            auto maybeTask = tasks(this, key);

            return maybeTask.match!(
                (Leaf leaf) {
                    // it's a leaf node aka input key, just return it
                    return store[key];
                },
                (ValueType!S delegate() @safe pure task) {
                    // it's an actual task, run it and store the new value
                    auto newValue = task();
                    store[key] = newValue;
                    return newValue;
                },
            );
        }

        alias fetch = build;
    }

    return Build();
}
