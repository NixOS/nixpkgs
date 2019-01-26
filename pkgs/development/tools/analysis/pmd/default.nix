{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "pmd-${version}";
  version = "6.10.0";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "mirror://sourceforge/pmd/pmd-bin-${version}.zip";
    sha256 = "1yzgin2lbhfswb07mm14wq8rn129kpfjidd8nv9pg77ywhnbwqmb";
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

