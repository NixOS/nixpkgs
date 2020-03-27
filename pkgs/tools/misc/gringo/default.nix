{ stdenv, fetchurl,
  bison, re2c, scons,
  libcxx
}:

let
  version = "4.5.4";
in

stdenv.mkDerivation {
  pname = "gringo";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/project/potassco/gringo/${version}/gringo-${version}-source.tar.gz";
    sha256 = "16k4pkwyr2mh5w8j91vhxh9aff7f4y31npwf09w6f8q63fxvpy41";
  };

  buildInputs = [ bison re2c scons.py2 ];

  patches = [
    ./gringo-4.5.4-cmath.patch
    ./gringo-4.5.4-to_string.patch
  ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace ./SConstruct \
      --replace \
        "env['CXX']            = 'g++'" \
        "env['CXX']            = '$CXX'"

    substituteInPlace ./SConstruct \
      --replace \
        "env['CPPPATH']        = []" \
        "env['CPPPATH']        = ['${libcxx}/include/c++/v1']"

    substituteInPlace ./SConstruct \
      --replace \
        "env['LIBPATH']        = []" \
        "env['LIBPATH']        = ['${libcxx}/lib']"
  '';

  buildPhase = ''
    scons WITH_PYTHON= --build-dir=release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/release/gringo $out/bin/gringo
  '';

  meta = with stdenv.lib; {
    description = "Converts input programs with first-order variables to equivalent ground programs";
    homepage = http://potassco.sourceforge.net/;
    platforms = platforms.all;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
