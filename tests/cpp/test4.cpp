// test4.cpp
// class inside namespace, indentation variation
// opening folds on lines: 11, 16, 27 (and on 9 if classes are also folded)

#include <iostream>

namespace test {

class Bar {
public:
    Bar() {
        // constructor definition here
        size = 0;
    }

    void foo() const {
        // code here for method declared and defined inline
        std::cout << size << '\n';
    }

private:
    void baz(int arg);  // declaration for private method
    int size;  // private member variable
};


void Bar::baz(int arg) {
    // method definition here
    size = arg;
}

} // namespace test
