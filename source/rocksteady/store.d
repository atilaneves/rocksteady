module rocksteady.store;


// A store using D's built-in associative array
struct StoreAA(K, V) {

    alias Key = K;
    alias Value = V;

    Value[Key] values;

    Value get(in Key key) const { return values[key]; }
    void store(in Key key, Value value) { values[key] = value; }
}
