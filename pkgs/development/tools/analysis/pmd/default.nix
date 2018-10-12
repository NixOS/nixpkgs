{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.8.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "1vfkg2l3sl5ahhs89nvkg0z1ah1k67c44nwpvaymq73rb2bb8ibr";
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out
  '';

  meta = with stdenv.lib; {
    description = "An extensible cross-language static code analyzer.";
    homepage = https://pmd.github.io/;
    platforms = platforms.unix;
    license = with licenses; [ bsdOriginal asl20 ];
  };
}

