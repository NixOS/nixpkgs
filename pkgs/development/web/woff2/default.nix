{ brotli, cmake, pkgconfig, fetchFromGitHub, stdenv, static ? false }:

stdenv.mkDerivation rec {
  pname = "woff2";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "woff2";
    rev = "v${version}";
    sha256 = "13l4g536h0pr84ww4wxs2za439s0xp1va55g6l478rfbb1spp44y";
  };

  outputs = [ "out" "dev" "lib" ];

  # Need to explicitly link to brotlicommon
  patches = stdenv.lib.optional static ./brotli-static.patch;

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}" ]
    ++ stdenv.lib.optional static "-DCMAKE_SKIP_RPATH:BOOL=TRUE";

  propagatedBuildInputs = [ brotli ];

  postPatch = ''
    # without this binaries only get built if shared libs are disable
    sed 's@^if (NOT BUILD_SHARED_LIBS)$@if (TRUE)@g' -i CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "Webfont compression reference code";
    homepage = "https://github.com/google/woff2";
    license = licenses.mit;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.unix;
  };
}
