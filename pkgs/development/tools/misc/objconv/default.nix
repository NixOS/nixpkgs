{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "objconv-${version}";
  version = "2.51";

  src = fetchurl {
    # Versioned archive of objconv sources maintained by orivej.
    url = "https://archive.org/download/objconv/${name}.zip";
    sha256 = "0wp6ld9vk11f4nnkn56627zmlv9k5vafi99qa3yyn1pgcd61zcfs";
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
