module rocksteady.types;


template MaybeTask(V) {
    import sumtype: SumType;
    alias Task = V delegate() @safe pure;
    alias MaybeTask = SumType!(Task, Leaf);
}


struct Leaf{}


auto leaf(V)() {
    return MaybeTask!V(Leaf());
}


auto task(F)(F func) {
    import std.traits: ReturnType;
    return MaybeTask!(ReturnType!F)(func);
}
