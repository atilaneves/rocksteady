module ut.spreadsheet;


import ut;


@("paper")
@safe pure unittest {

    import std.typecons: nullable, Nullable;
    import std.functional: toDelegate;

    static auto cells(in string cellName) {
        switch(cellName) {

        default:
            return Nullable!(int delegate(int delegate(string) @safe) @safe)();

        case "B1":
            // B1: A1 + A2
            return nullable(((int delegate(string) @safe fetch) => fetch("A1") + fetch("A2")).toDelegate);

        case "B2":
            // B2: B1 * 2
            return nullable(((int delegate(string) @safe fetch) => fetch("A1") + fetch("A2")).toDelegate);
        }
    }


    static auto busy(T, K, S)(T tasks, in K key, ref S store) {
        auto update = tasks(key);
        if(update.isNull) return store.getValue(key);
        auto updateFunc = update.get;
        pragma(msg, "updateFunc type: ", typeof(updateFunc));
        auto fetch = (&busy!(T, K, S)).toDelegate;
        pragma(msg, "fetch type: ", typeof(fetch));
        auto newValue = updateFunc(fetch);
        store.storeValue(key, newValue);
    }

    static struct Store {
        int[string] values;

        int getValue(in string key) @safe pure const { return values[key]; }
        void storeValue(in string key, in int value) @safe pure { values[key] = value; }
    }

    auto store = Store();
    store.storeValue("A1", 10);
    store.storeValue("A2", 20);

    busy(&cells, "B2", store);
}
