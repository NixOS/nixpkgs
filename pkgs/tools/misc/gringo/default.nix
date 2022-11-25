{ lib, stdenv, fetchurl, fetchpatch,
  bison, re2c, sconsPackages,
  libcxx, libcxxabi
}:

stdenv.mkDerivation rec {
  pname = "gringo";
  version = "4.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/potassco/gringo/${version}/gringo-${version}-source.tar.gz";
    sha256 = "16k4pkwyr2mh5w8j91vhxh9aff7f4y31npwf09w6f8q63fxvpy41";
  };

  nativeBuildInputs = [ sconsPackages.scons_latest ];

  buildInputs = [ bison re2c ];

  patches = [
    (fetchpatch {
      name = "sconscript-to-python3.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/gringo/sconscript-to-python3.patch?id=91d09eea75c1443c1d776f4d22193cbde18da491";
      hash = "sha256-SvrewHv5ThCMGbdbj48xOqHBnXYpwTyPNG3Ia8I7puU=";
    })
    ./gringo-4.5.4-cmath.patch
    ./gringo-4.5.4-to_string.patch
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace ./SConstruct \
      --replace \
        "env['CXX']            = 'g++'" \
        "env['CXX']            = '$CXX'"

    substituteInPlace ./SConstruct \
      --replace \
        "env['CPPPATH']        = []" \
        "env['CPPPATH']        = ['${lib.getDev libcxx}/include/c++/v1']"

    substituteInPlace ./SConstruct \
      --replace \
        "env['LIBPATH']        = []" \
        "env['LIBPATH']        = ['${lib.getLib libcxx}/lib', '${lib.getLib libcxxabi}/lib']"
  '' + ''
    sed '1i#include <limits>' -i libgringo/gringo/{control,term}.hh
  '';

  buildPhase = ''
    scons WITH_PYTHON= --build-dir=release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/release/gringo $out/bin/gringo
  '';

  meta = with lib; {
    description = "Converts input programs with first-order variables to equivalent ground programs";
    homepage = "http://potassco.sourceforge.net/";
    platforms = platforms.all;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
