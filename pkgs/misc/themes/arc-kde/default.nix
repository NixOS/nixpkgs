{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "arc-kde-theme";
  version = "2017-11-09";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "arc-kde";
    rev = "a0abe6fc5ebf74f9ae88b8a2035957cc16f706f5";
    sha256 = "1p6f4ny97096nb054lrgyjwikmvg0qlbcnsjag7m5dfbclfnvzkg";
  };

  makeFlags = ["PREFIX=$(out)" ];

  # Make this a fixed-output derivation
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  ouputHash = "2c2def57092a399aa1c450699cbb8639f47d751157b18db17";

  meta = {
    description = "A port of the arc theme for Plasma";
    homepage = https://git.io/arc-kde;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.nixy ];
    platforms = stdenv.lib.platforms.all;
  };
}
