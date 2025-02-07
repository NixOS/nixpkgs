{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  tailwindcss_4,
}:
let
  version = "4.0.4";
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "tailwindcss has not been packaged for ${system} yet.";

  plat =
    {
      aarch64-darwin = "macos-arm64";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "macos-x64";
      x86_64-linux = "linux-x64";
    }
    .${system} or throwSystem;

  hash =
    {
      aarch64-darwin = "sha256-hH9+h6jtXS9uT5mujDRTtjRM2onG8ZQsexOlMaIoXv4=";
      aarch64-linux = "sha256-wFUHnzVrwg/NsWEKHXMvgHSX8AuXUgwcktBt8fahu3A=";
      x86_64-darwin = "sha256-iMPHW3snWY9nWgRv6+0IS3Zh29LC0kYmzfwOcJM8xN0=";
      x86_64-linux = "sha256-ni5tivbbuV3U31ydmd9jBLBd8dH3cAAPFwSHmRAXubQ=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation {
  inherit version;
  pname = "tailwindcss_4";

  src = fetchurl {
    url =
      "https://github.com/tailwindlabs/tailwindcss/releases/download/v${version}/tailwindcss-" + plat;
    inherit hash;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    install -D $src $out/bin/tailwindcss
  '';

  passthru.tests.helptext = runCommand "tailwindcss-test-helptext" { } ''
    ${tailwindcss_4}/bin/tailwindcss --help > $out
  '';
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Command-line tool for the CSS framework with composable CSS classes, standalone v4 CLI";
    homepage = "https://tailwindcss.com/blog/tailwindcss-v4";
    license = licenses.mit;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = [ maintainers.adamjhf ];
    mainProgram = "tailwindcss";
    platforms = platforms.darwin ++ platforms.linux;
  };
}
