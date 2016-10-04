{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "objconv-${version}";
  version = "2.16";

  src = fetchFromGitHub {
    owner  = "vertis";
    repo   = "objconv";
    rev    = "${version}";
    sha256 = "1by2bbrampwv0qy8vn4hhs49rykczyj7q8g373ym38da3c95bym2";
  };

  buildPhase = "c++ -o objconv -O2 src/*.cpp";

  installPhase = "mkdir -p $out/bin && mv objconv $out/bin";

  meta = with stdenv.lib; {
    description = "Used for converting object files between COFF/PE, OMF, ELF and Mach-O formats for all 32-bit and 64-bit x86 platforms.";
    homepage = http://www.agner.org/optimize/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; unix;
  };

}
