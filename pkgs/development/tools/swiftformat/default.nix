{
  stdenv,
  lib,
  fetchurl,
  unzip,
  swiftformat,
  testers,
}:

let
  srcName = if stdenv.isDarwin then "swiftformat" else "swiftformat_linux";
in
stdenv.mkDerivation rec {
  pname = "swiftformat";
  version = "0.54.5";

  src = fetchurl {
    url = "https://github.com/nicklockwood/SwiftFormat/releases/download/${version}/${srcName}.zip";
    hash =
      if stdenv.isDarwin then
        "sha256-R8GziLeWlJT2cPHhIzD3SBE2IvZsnh8xacYXXKgHfWc="
      else
        "sha256-Uf09R6MpWdRy0CldGZswq24l4MyvNQ26fE47DvX9ypA=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  unpackPhase = ''
    unzip -j $src ${srcName}
    mkdir -p $out/bin
    mv ${srcName} $out/bin/swiftformat
  '';

  passthru.tests.version = testers.testVersion { package = swiftformat; };

  meta = with lib; {
    description = "Code formatting and linting tool for Swift";
    homepage = "https://github.com/nicklockwood/SwiftFormat";
    license = licenses.mit;
    maintainers = [ maintainers.bdesham ];
    platforms = platforms.darwin ++ [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
