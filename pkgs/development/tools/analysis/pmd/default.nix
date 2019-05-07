{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.14.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "0k40l93fxakms9vm641d4vlb68gfhkblrm24sb7slzvhq2v832dj";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';

  meta = with stdenv.lib; {
    description = "An extensible cross-language static code analyzer";
    homepage = https://pmd.github.io/;
    platforms = platforms.unix;
    license = with licenses; [ bsdOriginal asl20 ];
  };
}

