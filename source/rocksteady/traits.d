module rocksteady.traits;


template KeyType(S) {
    import std.traits: isAssociativeArray;

    static if(isAssociativeArray!S) {
        static import std.traits;
        alias KeyType = std.traits.KeyType!S;
    } else
        alias KeyType = S.Key;
}


template ValueType(S) {
    import std.traits: isAssociativeArray;

    static if(isAssociativeArray!S) {
        static import std.traits;
        alias ValueType = std.traits.ValueType!S;
    } else
        alias ValueType = S.Value;
}


template MaybeTask(K) {
    import std.typecons: Nullable;
    alias MaybeTask = Nullable!(K delegate() @safe pure);
}
