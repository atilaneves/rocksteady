module ut.spreadsheet;


import ut;


@("paper")
@safe pure unittest {

    import std.typecons: nullable;

    static MaybeTask!int formulae(F)(in string cellName, F fetch) {
        switch(cellName) {

        default:  // leaf node
            return typeof(return).init;

        case "B1": // B1: A1 + A2
            return nullable(() => fetch("A1") + fetch("A2"));

        case "B2": // B2: B1 * 2
            return nullable(() => fetch("B1") * 2);
        }
    }

    auto store = ["A1": 10, "A2": 20];
    auto b = busy!formulae(store);
    store.should == ["A1": 10, "A2": 20];  // nothing happened yet

    b.build("B2");
    // Should have built B1 as part of building B2
    store.should == [ "A1": 10, "A2": 20, "B1": 30, "B2": 60];
}
