{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.13.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "1g8ds38zwprjswm71y7l10l15rbh2s6ha9xpp20wjy823q9agbpq";
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

