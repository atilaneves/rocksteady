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

        S.Value build(in S.Key key) @safe pure const {
            auto maybeTask = tasks(key);
            if(maybeTask.isNull) return store.get(key);

            auto task = maybeTask.get;

            S.Value fetch(in S.Key key) {
                return build(key);
            }

            auto newValue = task(&fetch);
            store.put(key, newValue);

            return newValue;
        }
    }

    return Build();
}
