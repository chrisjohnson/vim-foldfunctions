// Should not collapse:
if (true) {
  // ...
}

function bar() {
  // ==== SHOULD NOT BE VISIBLE ====
}

var funky = function() {
  // ==== SHOULD NOT BE VISIBLE ====
}
