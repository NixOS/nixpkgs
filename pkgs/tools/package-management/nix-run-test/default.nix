{ substituteAll, lib, nix }:

substituteAll {
  name = "nix-run-test";

  dir = "bin";
  isExecutable = true;

  src = ./nix-run-test.sh;

  meta = {
    description = "Tool to run nix tests";
    maintainers = [ lib.maintainers.ericsagnes ];
    license     = lib.licenses.mit;
    platforms   = nix.meta.platforms;
  };
}
