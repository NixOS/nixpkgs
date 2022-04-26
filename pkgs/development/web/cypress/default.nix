{ callPackage
, lib
, stdenv
}:

let
  pname = "cypress";
  packages = builtins.fromJSON (lib.readFile ./packages.json);
  version = packages.version;
  meta = with lib; {
    description = "Fast, easy and reliable testing for anything that runs in a browser";
    homepage = "https://www.cypress.io";
    license = licenses.mit;
  };
  package = if stdenv.isLinux then ./linux.nix else ./darwin.nix;
  src = if stdenv.isLinux then packages.packages.linux else packages.packages.darwin;
  mkPackage = callPackage package {};
in mkPackage { inherit meta pname src version; }
