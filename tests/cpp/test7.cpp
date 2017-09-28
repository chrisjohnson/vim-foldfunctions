// test7.cpp
// lambda function should not be folded (probably)

#include <vector>
#include <algorithm>

namespace test {

    void foo() {
        // code here
        auto v = std::vector{3, 1, 4, 1, 5, 9, 2};

        std::for_each(v.begin(), v.end(),
                [] (int& element) {
                    element += 1;
                });
    }

} // namespace test
