{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, gfortran
, texinfo
, python3
, boost
  # Select SIMD alignment width (in bytes) for vectorization.
, simdWidth ? 1
  # Pad arrays to simdWidth by default?
  # Note: Only useful if simdWidth > 1
, enablePadding ? false
  # Activate serialization through Boost.Serialize?
, enableSerialization ? true
  # Activate test-suite?
  # WARNING: Some of the tests require up to 1700MB of memory to compile.
, doCheck ? true
}:

let
  inherit (lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "blitz++";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "blitzpp";
    repo = "blitz";
    rev = version;
    hash = "sha256-wZDg+4lCd9iHvxuQQE/qs58NorkxZ0+mf+8PKQ57CDE=";
  };

  patches = [
    # https://github.com/blitzpp/blitz/pull/180
    (fetchpatch {
      name = "use-cmake-install-full-dir.patch";
      url = "https://github.com/blitzpp/blitz/commit/020f1d768c7fa3265cec244dc28f3dc8572719c5.patch";
      hash = "sha256-8hYFNyWrejjIWPN/HzIOphD4Aq6Soe0FFUBmwV4tpWQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    texinfo
  ];

  buildInputs = [ gfortran texinfo boost ];

  cmakeFlags = optional enablePadding "-DARRAY_LENGTH_PADDING=ON"
    ++ optional enableSerialization "-DENABLE_SERIALISATION=ON"
    ++ optional stdenv.is64bit "-DBZ_FULLY64BIT=ON";
    # FIXME ++ optional doCheck "-DBUILD_TESTING=ON";

  # skip broken library name detection
  ax_boost_user_serialization_lib = lib.optionalString stdenv.isDarwin "boost_serialization";

  enableParallelBuilding = true;

  inherit doCheck;

  meta = with lib; {
    description = "Fast multi-dimensional array library for C++";
    homepage = "https://sourceforge.net/projects/blitz/";
    license = with licenses; [ artistic2 /* or */ bsd3 /* or */ lgpl3Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ ToxicFrog ];
    longDescription = ''
      Blitz++ is a C++ class library for scientific computing which provides
      performance on par with Fortran 77/90. It uses template techniques to
      achieve high performance. Blitz++ provides dense arrays and vectors,
      random number generators, and small vectors (useful for representing
      multicomponent or vector fields).
    '';
  };
}
