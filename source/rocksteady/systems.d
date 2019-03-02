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
auto busy(T, K, S)(T tasks, in K key, ref S store)
    @safe pure  // FIXME: why is this not being inferred?
{

    auto maybeTask = tasks(key);
    if(maybeTask.isNull) return store.get(key);

    auto task = maybeTask.get;

    auto fetch(in K key) {
        return busy(tasks, key, store);
    }

    auto newValue = task(&fetch);
    store.store(key, newValue);

    return newValue;
}
