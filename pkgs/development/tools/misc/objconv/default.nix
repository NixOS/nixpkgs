{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "objconv-${version}";
  version = "2.44";

  src = fetchurl {
    # Versioned archive of objconv sources maintained by orivej.
    url = "https://archive.org/download/objconv/${name}.zip";
    sha256 = "1dlnpv8qwz0rwivpbgk84kmsjz3vh1i149z44ha2dvg8afzyfhjl";
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

  meta = with stdenv.lib; {
    description = "Object and executable file converter, modifier and disassembler";
    homepage = http://www.agner.org/optimize/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej vrthra ];
    platforms = platforms.unix;
  };
}
