import reggae;
import std.typecons: Yes;


enum debugFlags = ["-g", "-debug"];


alias ut = dubTestTarget!(
    CompilerFlags(debugFlags),
    LinkerFlags(),
    CompilationMode.package_,
);


mixin build!(ut);
