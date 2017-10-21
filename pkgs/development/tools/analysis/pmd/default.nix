{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "5.2.3";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "03frkyiii7304qrcypdqcxqxjf5n3p59zjib0r802mbbx1nzcisn";
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

