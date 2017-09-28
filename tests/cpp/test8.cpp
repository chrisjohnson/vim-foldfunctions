// test8.cpp
// function should be folded, but not namespace
// namespace can be used without indenting

#include <cassert>

namespace test {

void foo() {
    // code here
    int my_var(5);  // variables can be initialised like this
    {   // a local scope, not a function (no fold here!)

        assert(my_var == 5);

    }
}

} // namespace test
