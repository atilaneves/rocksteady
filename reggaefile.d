import reggae;
import std.typecons: Yes;


enum debugFlags = ["-g", "-debug"];


alias ut = dubTestTarget!(
    CompilerFlags(debugFlags),
);


mixin build!(ut);
