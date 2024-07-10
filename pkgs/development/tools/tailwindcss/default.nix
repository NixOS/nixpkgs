{ lib
, fetchurl
, stdenv
, runCommand
, tailwindcss
,
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "tailwindcss has not been packaged for ${system} yet.";

  plat = {
    aarch64-darwin = "macos-arm64";
    aarch64-linux = "linux-arm64";
    armv7l-linux = "linux-armv7";
    x86_64-darwin = "macos-x64";
    x86_64-linux = "linux-x64";
  }.${system} or throwSystem;

  hash = {
    aarch64-darwin = "sha256-ubXwWgg4QAwM27meaIjT/HjgoVs9cVUiGNWoGRLktBI=";
    aarch64-linux = "sha256-vd1hRTAGLI3Kv/FmYICKTSajyneh+F9vM1+gnqGthGs=";
    armv7l-linux = "sha256-Jl5H+MZUMBZOBmHgzpM/S7lAY4F1KtRS0G7Vu7ORKgg=";
    x86_64-darwin = "sha256-SL0DjE1ssPlypsWbhxq/YgSUYtdqOXkb6EktfmAAXkQ=";
    x86_64-linux = "sha256-18MbsqzYcr9hsON5hZujEBzvi7vyQzpYZOCitYYq5HY=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "tailwindcss";
  version = "3.4.4";

  src = fetchurl {
    url = "https://github.com/tailwindlabs/tailwindcss/releases/download/v${version}/tailwindcss-${plat}";
    inherit hash;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/tailwindcss
    chmod 755 $out/bin/tailwindcss
  '';

  passthru.tests.helptext = runCommand "tailwindcss-test-helptext" { } ''
    ${tailwindcss}/bin/tailwindcss --help > $out
  '';
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Command-line tool for the CSS framework with composable CSS classes, standalone CLI";
    homepage = "https://tailwindcss.com/blog/standalone-cli";
    license = licenses.mit;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = [ maintainers.adamcstephens ];
    mainProgram = "tailwindcss";
    platforms = platforms.darwin ++ platforms.linux;
  };
}
