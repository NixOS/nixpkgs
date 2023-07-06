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
    aarch64-darwin = "sha256-GXSFDXRBGnEgqfISou85Ivd5npjZB7aMsfrQ2Y+EN0g=";
    aarch64-linux = "sha256-H2kbeso8/566czi1pEyip5rAgFJQYfdLnAImP25tDe0=";
    armv7l-linux = "sha256-52XyCmsjuHKs3aGUaAA0uQxGTY06k8gxK/fLYSVdP74=";
    x86_64-darwin = "sha256-8gwu/sVTjQGE4mSdxtk7ivQyAiRwCuL0Ot/aCrER/as=";
    x86_64-linux = "sha256-W9JRBB4JDTighDry21ukaFm1H1iKyg7HVG9RJHmIn2Q=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "tailwindcss";
  version = "3.3.2";

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
    platforms = platforms.darwin ++ platforms.linux;
  };
}
