// test6.cpp
// function should be folded, but not namespace or scopes

namespace test {

    void foo() {
        // code here

        {
            // code in a scope
        }

        {
            // another scope
        }

        if (true) {
            // don't fold an if block
        }

        while (false) {
            // don't fold a while loop block
        }

        for (int i = 0; i < 10; ++i) {
            // don't fold a for loop block
        }

        do {
            // do while loop
        } while (false);
    }

} // namespace test
