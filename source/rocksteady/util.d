module rocksteady.util;


K[] dependencies(alias tasks, V, K)(in K key) @safe pure {

    import rocksteady.types: Leaf;
    import rocksteady.traits: TaskType;
    import sumtype: match;

    K[] ret;

    V fetch(in K key) {
        ret ~= key;
        ret ~= dependencies!(tasks, V)(key);
        return V.init;
    }

    auto maybeTask = tasks(key, &fetch);
    return maybeTask.match!(
        (Leaf _) => ret,
        (TaskType!V task) {
            task();
            return ret;
        }
    );
}
