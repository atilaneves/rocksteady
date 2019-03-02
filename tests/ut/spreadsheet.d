module ut.spreadsheet;


import ut;


@("paper")
@safe pure unittest {

    import std.typecons: nullable, Nullable;
    import std.functional: toDelegate;

    static auto cells(in string cellName) @trusted /* toDelegate */ {
        switch(cellName) {

        default:
            return Nullable!(int delegate(int delegate(in string) @safe pure) @safe pure)();

        case "B1": // B1: A1 + A2
            return nullable(((int delegate(in string) @safe pure fetch) => fetch("A1") + fetch("A2")).toDelegate);

        case "B2": // B2: B1 * 2
            return nullable(((int delegate(in string) @safe pure fetch) => fetch("B1") * 2).toDelegate);
        }
    }

    static void busy(T, K, S)(T tasks, in K key, ref S store) pure {

        S.Value fetch(in K key) @safe pure {
            auto maybeTask = tasks(key);
            if(maybeTask.isNull) return store.get(key);

            auto task = maybeTask.get;
            auto newValue = task(&fetch);
            store.store(key, newValue);

            return newValue;
        }

        fetch(key);
    }

    static struct Store {

        alias Key = string;
        alias Value = int;

        int[string] values;

        int get(in string key) @safe pure const { return values[key]; }
        void store(in string key, in int value) @safe pure { values[key] = value; }
    }

    auto store = Store(["A1": 10, "A2": 20]);

    busy(&cells, "B2", store);
    store.values.should == [ "A1": 10, "A2": 20, "B1": 30, "B2": 60];
}
