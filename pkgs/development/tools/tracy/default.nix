{ stdenv, lib, darwin, fetchFromGitHub, tbb, gtk2, glfw, pkgconfig, freetype, Carbon, AppKit }:

stdenv.mkDerivation rec {
  name    = "tracy-${version}";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    rev = "v${version}";
    sha256 = "0pgq8h5gq141zq1k4cgj6cp74kh4zqbp7h4wh29q4grjb04yy06i";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glfw ]
    ++ lib.optionals stdenv.isDarwin [ Carbon AppKit freetype ]
    ++ lib.optionals stdenv.isLinux [ gtk2 tbb ];

  NIX_CFLAGS_COMPILE = []
    ++ lib.optional stdenv.isLinux "-ltbb"
    ++ lib.optional stdenv.cc.isClang "-faligned-allocation";

  buildPhase = ''
    make -j $NIX_BUILD_CORES -C profiler/build/unix release
    make -j $NIX_BUILD_CORES -C import-chrome/build/unix/ release
  '';

  installPhase = ''
    install -D ./profiler/build/unix/Tracy-release $out/bin/Tracy
    install -D ./import-chrome/build/unix/import-chrome-release $out/bin/import-chrome
  '';

  meta = with stdenv.lib; {
    description = "A real time, nanosecond resolution, remote telemetry frame profiler for games and other applications.";
    homepage = "https://github.com/wolfpld/tracy";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mpickering ];
  };
}
