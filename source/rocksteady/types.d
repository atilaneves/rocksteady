module rocksteady.types;


template MaybeTask(V) {
    import rocksteady.traits: TaskType;
    import sumtype: SumType;
    alias MaybeTask = SumType!(TaskType!V, Leaf);
}


struct Leaf{}


auto leaf(V)() {
    return MaybeTask!V(Leaf());
}


auto task(F)(F func) {
    import std.traits: ReturnType;
    return MaybeTask!(ReturnType!F)(func);
}
