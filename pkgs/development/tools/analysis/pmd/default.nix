{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.3.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "09x6mpqz4z583lvliipkmvlv3qmmwi7zjzgfjhwyp27faf2pz1ym";
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

