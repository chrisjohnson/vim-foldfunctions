function foo() {
  // ==== SHOULD NOT BE VISIBLE ====
}

class Bar {
  something () {
    // ==== SHOULD NOT BE VISIBLE ====
  }
}

/*
 * Should be visible:
class Bar {
  something () {
    // Should be visible
  }
}
*/
