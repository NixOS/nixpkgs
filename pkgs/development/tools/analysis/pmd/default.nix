{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.12.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "1fayb62i6p21q1d6y7ixljf37r7n7vwjwa69q5z6wr4zspaj79f9";
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

