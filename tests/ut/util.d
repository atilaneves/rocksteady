module ut.util;


import ut;


@("dependencies.spreadsheet.static")
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

    dependencies!(formulae, int)("B1").should == ["A1", "A2"];
}
