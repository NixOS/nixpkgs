# NOTE: the `nixpkgs` version of this file is copied from the upstream repository
# for this package. Please make any changes to https://github.com/timbertson/gup/

{ stdenv, lib, pythonPackages }:
{ src, version, meta ? {}, passthru ? {}, forceTests ? false }:
let
  testInputs = [
    pythonPackages.mocktest or null
    pythonPackages.whichcraft
    pythonPackages.nose
    pythonPackages.nose_progressive
  ];
  pychecker = pythonPackages.pychecker or null;
  usePychecker = forceTests || pychecker != null;
  enableTests = forceTests || (lib.all (dep: dep != null) testInputs);
in
stdenv.mkDerivation {
  inherit src meta passthru;
  name = "gup-${version}";
  buildInputs = [ pythonPackages.python ]
    ++ (lib.optionals enableTests testInputs)
    ++ (lib.optional usePychecker pychecker)
  ;
  SKIP_PYCHECKER = !usePychecker;
  buildPhase = "make python";
  inherit pychecker;
  testPhase = if enableTests then "make test" else "true";
  installPhase = ''
    mkdir $out
    cp -r python/bin $out/bin
  '';
}
