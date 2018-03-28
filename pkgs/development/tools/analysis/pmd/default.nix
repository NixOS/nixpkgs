{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.1.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "1d2hbsnyvwvawhfh832yy3w93kr4whrk99zpg4q5ws2b2hhdvzv8";
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

