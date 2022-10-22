{ pkgs, stdenv, lib, testers, mongosh }:

let
  nodePackages = import ./gen/composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.mongosh.override {
  passthru.tests.version = testers.testVersion {
    package = mongosh;
  };

  meta = with lib; {
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "The MongoDB Shell";
    maintainers = with maintainers; [ aaronjheng ];
    license = licenses.asl20;
    mainProgram = "mongosh";
  };
}
