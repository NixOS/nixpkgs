{
  lib,
  haskell,
}:

lib.recurseIntoAttrs {
  simpleStackProject = haskell.lib.buildStackProject {
    pname = "stack-test-simple-project";
    version = "0.1.0.0";
    src = ./local;

    meta = {
      description = "Nixpkgs stack test case";
      license = lib.licenses.mit;
      mainProgram = "local";
    };
  };
}
