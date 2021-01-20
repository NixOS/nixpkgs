{ stdenv, lib, darwin, fetchFromGitHub, tbb, gtk3, glfw, pkg-config, freetype, Carbon, AppKit, capstone }:

stdenv.mkDerivation rec {
  pname = "tracy";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    rev = "v${version}";
    sha256 = "0s39kimpc03x48kh7lyhblfs8y4mdzcz3g7f806h90x7zndsmfxj";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glfw capstone ]
    ++ lib.optionals stdenv.isDarwin [ Carbon AppKit freetype ]
    ++ lib.optionals stdenv.isLinux [ gtk3 tbb ];

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

  fixupPhase = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libcapstone.4.dylib ${capstone}/lib/libcapstone.4.dylib $out/bin/Tracy
  '';

  meta = with lib; {
    description = "A real time, nanosecond resolution, remote telemetry frame profiler for games and other applications";
    homepage = "https://github.com/wolfpld/tracy";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mpickering nagisa ];
  };
}
