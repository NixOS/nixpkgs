{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "adapta-kde-theme-${version}";
  version = "20180512";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "adapta-kde";
    rev = version;
    sha256 = "1lgpkylhzbayk892inql16sjyy9d3v126f9i1v7qgha1203rwcji";
  };

  makeFlags = ["PREFIX=$(out)" ];

  # Make this a fixed-output derivation
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  ouputHash = "0rxhk8sp81vb2mngqr7kn9vlqyliq9aqj2d25igcr01v5axbxbzb";

  meta = {
    description = "A port of the Adapta theme for Plasma";
    homepage = https://git.io/adapta-kde;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.tadfisher ];
    platforms = stdenv.lib.platforms.all;
  };
}
