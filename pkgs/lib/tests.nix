let lib = import ./default.nix;

  miscTests = import ./misc-tests.nix;

in
  if lib.all (a : a == "ok") (lib.concatLists [ miscTests ]) then
    throw "all tests have passed"
    else "there has been a some lib test failures"
