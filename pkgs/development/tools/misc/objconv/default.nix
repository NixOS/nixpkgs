{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "objconv";
  version = "2.52";

  src = fetchurl {
    # Versioned archive of objconv sources maintained by orivej.
    url = "https://archive.org/download/objconv/${pname}-${version}.zip";
    sha256 = "0r117r7yvqvvdgwgwxpkyzi6p5nm0xb6p67wvkmvggm9fdyl3z8v";
  };

  nativeBuildInputs = [ unzip ];

  outputs = [ "out" "doc" ];

  unpackPhase = ''
    mkdir -p "$name"
    cd "$name"
    unpackFile "$src"
    unpackFile source.zip
  '';

  buildPhase = "c++ -o objconv -O2 *.cpp";

  installPhase = ''
    mkdir -p $out/bin $out/doc/objconv
    mv objconv $out/bin
    mv objconv-instructions.pdf $out/doc/objconv
  '';

  meta = with lib; {
    description = "Object and executable file converter, modifier and disassembler";
    homepage = "https://www.agner.org/optimize/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej vrthra ];
    platforms = platforms.unix;
  };
}
