{
  lib,
  fetchurl,
  stdenv,
  runCommand,
  tailwindcss,
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "tailwindcss has not been packaged for ${system} yet.";

  plat =
    {
      aarch64-darwin = "macos-arm64";
      aarch64-linux = "linux-arm64";
      armv7l-linux = "linux-armv7";
      x86_64-darwin = "macos-x64";
      x86_64-linux = "linux-x64";
    }
    .${system} or throwSystem;

  hash =
    {
      aarch64-darwin = "sha256-y1//nTmNDU8hw3wumVeK2kN2b7xoB7X5Kdg16/0HUms=";
      aarch64-linux = "sha256-o1jubyQBq/z83CPzTII6ZclZUHVXVahsu024GXFrxX8=";
      armv7l-linux = "sha256-+hb5ahgDCLSoR5o3YovdDp6igbXkHhxu0Lu1iY8Xros=";
      x86_64-darwin = "sha256-raeEz+Kd3cfzPGTKC79h51vcXpGGDRuZY7luDGZphbs=";
      x86_64-linux = "sha256-haR0CRyHcK8hXUAkW968Ui6vGpiPP5V1mi7n6lOS71M=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "tailwindcss";
  version = "3.4.14";

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
