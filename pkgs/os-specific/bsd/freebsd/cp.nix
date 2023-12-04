{ mkDerivation, ...}:
mkDerivation {
  path = "bin/cp";
  NIX_DEBUG = 1;

  extraPaths = [
    "sys"
  ];

  postPatch = ''
    substituteInPlace $BSDSRCDIR/bin/cp/Makefile --replace 'tests' ""
  '';
}
