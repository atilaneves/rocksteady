module ut.spreadsheet;


import ut;


@("paper")
@safe pure unittest {

    import std.typecons: nullable, Nullable;
    import std.functional: toDelegate;

    alias Fetch = int delegate(in string) @safe pure;
    alias MaybeTask = Nullable!(int delegate(Fetch) @safe pure);

    static MaybeTask formulae(in string cellName) @trusted /* toDelegate */ {
        switch(cellName) {

        default:  // leaf node
            return typeof(return).init;

        case "B1": // B1: A1 + A2
            return nullable(((Fetch fetch) => fetch("A1") + fetch("A2")).toDelegate);

        case "B2": // B2: B1 * 2
            return nullable(((Fetch fetch) => fetch("B1") * 2).toDelegate);
        }
    }

    auto store = StoreAA!(string, int)(["A1": 10, "A2": 20]);

    auto b = busy!formulae(store);
    store.values.should == ["A1": 10, "A2": 20]; // nothing happened yet

    b.build("B2");
    // Should have built B1 as part of building B2
    store.values.should == [ "A1": 10, "A2": 20, "B1": 30, "B2": 60];
}
