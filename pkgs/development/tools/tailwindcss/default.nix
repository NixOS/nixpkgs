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
      aarch64-darwin = "sha256-odDHmFdZrMygvxLlGsHcvw9s8v/7Yubg9i0JHEd6EKM=";
      aarch64-linux = "sha256-abE3i4EzGS19L+sSoRb6EtA1WU9Y2z7/IVh55K2M85s=";
      armv7l-linux = "sha256-cE59ka+6bh9jCImv0NfbNrRjTmKFEswUHVBKW+riiGA=";
      x86_64-darwin = "sha256-bL2tdL53bAh/+l6aBXUSxUiY+f6IKNM2IhLf4y/JM6M=";
      x86_64-linux = "sha256-fST3+hkdIZO3jNX1pCpgk+FECVIZCFKfQtgLEf3h8dQ=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "tailwindcss";
  version = "3.4.17";

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
