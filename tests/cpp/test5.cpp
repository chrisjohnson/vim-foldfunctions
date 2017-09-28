// test5.cpp
// class inside namespace with inner class
// opening folds on lines: 11, 18, 23 (and on 9 and 16 if classes are also folded)

#include <iostream>

namespace test {

class Bar {
public:
    Bar() {
        // constructor definition here
        size = 0;
    }

    class InnerBar {
    public:
        void foo() const {
            // code here for method declared and defined inline
        }

    private:
        void boop() {
            // code here for method declared and defined inline
        }
    };

private:
    void baz(int arg);  // declaration for private method
    int size;  // private member variable
};


void Bar::baz(int arg) {
    // method definition here
    size = arg;
}

} // namespace test
