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
    aarch64-darwin = "sha256-tlsAztU6Rk7xq1T3NNDlB0Gt3iRpvAk72VO+gGuYEps=";
    aarch64-linux = "sha256-bYe/QJ7UuMq5tDhhof/83gfUN0DbenQu/wbrvLylKeM=";
    armv7l-linux = "sha256-d0kK0clkSUW4ARTNUVWpmJidXwxLucjC4Vwu924YB1E=";
    x86_64-darwin = "sha256-4cvrHklkQ0fo7fVi1aRKOMhX4ky7dENwGh2jqTneQLo=";
    x86_64-linux = "sha256-FX0N1WmV9pixd3ZoBXnSdBSSDBqj//S8e5nEaQuEdxc=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "tailwindcss";
  version = "3.3.3";

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
