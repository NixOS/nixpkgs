{ stdenv, lib, darwin, fetchFromGitHub, tbb, gtk3, glfw, pkg-config, freetype, Carbon, AppKit, capstone }:

let
  disableLTO = stdenv.cc.isClang && stdenv.isDarwin;  # workaround issue #19098
in stdenv.mkDerivation rec {
  pname = "tracy";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    rev = "v${version}";
    sha256 = "sha256-jp+Geqk39ZPoe2KzUJJ0w5hvCnyUlHGwVKn73lJJt94=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glfw capstone ]
    ++ lib.optionals stdenv.isDarwin [ Carbon AppKit freetype ]
    ++ lib.optionals stdenv.isLinux [ gtk3 tbb ];

  NIX_CFLAGS_COMPILE = [ ]
    ++ lib.optional stdenv.isLinux "-ltbb"
    ++ lib.optional stdenv.cc.isClang "-faligned-allocation"
    ++ lib.optional disableLTO "-fno-lto";

  NIX_CFLAGS_LINK = lib.optional disableLTO "-fno-lto";

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

  postFixup = lib.optionalString stdenv.isDarwin ''
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
