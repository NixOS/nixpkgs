{ stdenv, fetchurl, premake5 }:

let version = "0.8.6"; in

let
  arch =
    {
      "i686-linux" = "x86";
      "x86_64-linux" = "x64";
    }.${stdenv.system} or (throw "platform ${stdenv.system} is not supported");
in

stdenv.mkDerivation {
  name = "otfcc-${version}";
  src = fetchurl {
    url = "https://github.com/caryll/otfcc/archive/v${version}.tar.gz";
    sha256 = "0kap52bzrn21fmph8j2pc71f80f38ak1p2fcczzmrh0hb1r9c8dd";
  };
  nativeBuildInputs = [ premake5 ];
  configurePhase = ''
    runHook preConfigure
    premake5 gmake
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    cd build/gmake
    make config=release_${arch}
    cd ../..
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -d "$out/lib"
    install "bin/release-${arch}/"lib* "$out/lib"
    install -d "$out/bin"
    install "bin/release-${arch}/"otfcc* "$out/bin"
    runHook postInstall
  '';
}
