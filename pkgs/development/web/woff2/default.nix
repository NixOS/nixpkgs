{ brotli, cmake, fetchFromGitHub, stdenv }:

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

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ brotli ];

  # without this binaries only get built if shared libs are disable
  patchPhase = ''
    sed 's@^if (NOT BUILD_SHARED_LIBS)$@if (TRUE)@g' -i CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "Webfont compression reference code";
    homepage = https://github.com/google/woff2;
    license = licenses.mit;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.unix;
  };
}
