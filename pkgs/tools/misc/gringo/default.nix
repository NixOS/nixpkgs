{ stdenv, fetchurl,
  bison, re2c, scons
}:

let
  version = "4.5.4";
in

stdenv.mkDerivation rec {
  name = "gringo-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/potassco/gringo/${version}/gringo-${version}-source.tar.gz";
    sha256 = "16k4pkwyr2mh5w8j91vhxh9aff7f4y31npwf09w6f8q63fxvpy41";
  };

  buildInputs = [ bison re2c scons ];

  patches = [
    ./gringo-4.5.4-cmath.patch
  ];

  buildPhase = ''
    scons --build-dir=release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/release/gringo $out/bin/gringo
  '';

  meta = with stdenv.lib; {
    description = "Converts input programs with first-order variables to equivalent ground programs";
    homepage = http://potassco.sourceforge.net/;
    platforms = platforms.linux;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
