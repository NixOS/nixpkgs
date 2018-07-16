{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.5.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "10jdgps1ikx75ljp2gi76ff7payg28pmiy5y3vp17gg47mv991aw";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';

  meta = {
    description = "Scans Java source code and looks for potential problems";
    homepage = http://pmd.sourceforge.net/;
    platforms = stdenv.lib.platforms.unix;
  };
}

