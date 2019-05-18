module ut.spreadsheet;


import ut;


@("static")
@safe pure unittest {

    import std.typecons: nullable;

    static MaybeTask!int formulae(B)(auto ref B bs, in string cellName) {
        switch(cellName) {

        default:  // leaf node
            return typeof(return).init;

        case "B1": // B1: A1 + A2
            return nullable(() => bs.fetch("A1") + bs.fetch("A2"));

        case "B2": // B2: B1 * 2
            return nullable(() => bs.fetch("B1") * 2);
        }
    }

    auto store = ["A1": 10, "A2": 20];
    auto b = busy!formulae(store);
    store.should == ["A1": 10, "A2": 20];  // nothing happened yet

    b.build("B2");
    // Should have built B1 as part of building B2
    store.should == [ "A1": 10, "A2": 20, "B1": 30, "B2": 60];
}


@("dynamic")
@safe pure unittest {

    import std.typecons: nullable;

    static MaybeTask!int formulae(B)(auto ref B bs, in string cellName) {
        switch(cellName) {

        default:  // leaf node
            return typeof(return).init;

        case "B1": // B1: IF(C1=1,B2,A2)
            return nullable(() => bs.fetch("C1") == 1 ? bs.fetch("B2") : bs.fetch("A2"));

        case "B2": // B2: IF(C1=1,A1,B1)
            return nullable(() => bs.fetch("C1") == 1 ? bs.fetch("A1") : bs.fetch("B1"));
        }
    }

    auto store = ["A1": 10, "A2": 20, "C1": 1];
    auto b = busy!formulae(store);
    store.should == ["A1": 10, "A2": 20, "C1": 1];  // nothing happened yet

    b.build("B2");
    store.should == [ "A1": 10, "A2": 20, "B2": 10, "C1": 1];

    b.build("B1");
    store.should == [ "A1": 10, "A2": 20, "B1": 10, "B2": 10, "C1": 1];

    store = ["A1": 30, "A2": 40, "C1": 0];
    b.build("B2");
    // Should build B1 as part of building B2
    store.should == [ "A1": 30, "A2": 40, "B1": 40, "B2": 40, "C1": 0];
}
