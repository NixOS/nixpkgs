{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "adapta-kde-theme-${version}";
  version = "2018-05-12";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "adapta-kde";
    rev = "31eacbb64a64dbcfe6f3546f7a15b6920036c3a2";
    sha256 = "1lgpkylhzbayk892inql16sjyy9d3v126f9i1v7qgha1203rwcji";
  };

  makeFlags = ["PREFIX=$(out)" ];

  # Make this a fixed-output derivation
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  ouputHash = "ba3bd4c13e8b73c528b5adcb667e985f7d60df78d50bc58707119cb9e242bb2c";

  meta = {
    description = "A port of the adapta theme for Plasma";
    homepage = https://git.io/adapta-kde;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.nixy ];
    platforms = stdenv.lib.platforms.all;
  };
}
