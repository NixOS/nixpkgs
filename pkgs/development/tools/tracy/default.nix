{ stdenv, lib, darwin, fetchFromGitHub, tbb, gtk2, glfw, pkgconfig, freetype, Carbon, AppKit, capstone }:

stdenv.mkDerivation rec {
  pname = "tracy";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    rev = "v${version}";
    sha256 = "07cmz2w7iv10f9i9q3fhg80s6riy9bxnk9xvc3q4lw47mc150skp";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glfw capstone ]
    ++ lib.optionals stdenv.isDarwin [ Carbon AppKit freetype ]
    ++ lib.optionals stdenv.isLinux [ gtk2 tbb ];

  NIX_CFLAGS_COMPILE = [ ]
    ++ lib.optional stdenv.isLinux "-ltbb"
    ++ lib.optional stdenv.cc.isClang "-faligned-allocation";

  buildPhase = ''
    make -j $NIX_BUILD_CORES -C profiler/build/unix release
    make -j $NIX_BUILD_CORES -C import-chrome/build/unix/ release
    make -j $NIX_BUILD_CORES -C capture/build/unix/ release
    make -j $NIX_BUILD_CORES -C update/build/unix/ release
  '';

  installPhase = ''
    install -D ./profiler/build/unix/Tracy-release $out/bin/Tracy
    install -D ./import-chrome/build/unix/import-chrome-release $out/bin/import-chrome
    install -D ./capture/build/unix/capture-release $out/bin/capture
    install -D ./update/build/unix/update-release $out/bin/update
  '';

  meta = with stdenv.lib; {
    description = "A real time, nanosecond resolution, remote telemetry frame profiler for games and other applications.";
    homepage = "https://github.com/wolfpld/tracy";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mpickering ];
  };
}
