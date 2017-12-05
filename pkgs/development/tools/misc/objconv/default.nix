{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "objconv-${version}";
  version = "2.48";

  src = fetchurl {
    # Versioned archive of objconv sources maintained by orivej.
    url = "https://archive.org/download/objconv/${name}.zip";
    sha256 = "1y4bmy99dfhyqykkib50fiwsha2a62s9ya1qsv5mwj21w1l0snj7";
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
