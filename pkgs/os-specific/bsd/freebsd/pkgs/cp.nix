{ mkDerivation }:
mkDerivation {
  path = "bin/cp";

  extraPaths = [ "sys" ];

  postPatch = ''
    substituteInPlace $BSDSRCDIR/bin/cp/Makefile --replace 'tests' ""
  '';
}
