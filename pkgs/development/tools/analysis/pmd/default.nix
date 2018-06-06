{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.4.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "17yjjmqcn1fy3bj73nh5i84yc7wappza612a0iwg0lqqn4yl7lyn";
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

