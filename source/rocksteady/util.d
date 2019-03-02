module rocksteady.util;


K[] dependencies(alias tasks, V, K)(in K key) @safe pure {

    import rocksteady.traits: MaybeTask;

    K[] ret;

    V fetch(in K key) {
        ret ~= key;
        ret ~= dependencies!(tasks, V)(key);
        return V.init;
    }

    auto maybeTask = tasks(key, &fetch);
    if(maybeTask.isNull) return ret;

    auto task = maybeTask.get;
    task();

    return ret;
}
