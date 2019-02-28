int main(string[] args) @safe {
    try {
        import rocksteady: run;
        run;
        return 0;
    } catch(Exception e) {
        import std.stdio: stderr;
        () @trusted { stderr.writeln("Error: ", e.msg); }();
        return 1;
    }
}
