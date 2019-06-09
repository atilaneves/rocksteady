module ut.util;


import ut;


@("dependencies.spreadsheet.static")
@safe pure unittest {
    import std.typecons: nullable;

    static MaybeTask!int spreadsheet(F)(in string cellName, F fetch) {
        switch(cellName) {

        default:  // leaf node
            return leaf!int;

        case "B1": // B1: A1 + A2
            return task(() => fetch("A1") + fetch("A2"));

        case "B2": // B2: B1 * 2
            return task(() => fetch("B1") * 2);
        }
    }

    dependencies!(spreadsheet, int)("B1").should == ["A1", "A2"];
}
