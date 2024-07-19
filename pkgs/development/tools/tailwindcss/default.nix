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
    aarch64-darwin = "sha256-9vRoGoYCJ1CGDOZtv6D3ZmH0HA3RTPIsB5SeGzCb+Dc=";
    aarch64-linux = "sha256-Z6NZ2izOWVxuiwqvoGitOHhQe8Y9lk7q73Tv4iYh6Ds=";
    armv7l-linux = "sha256-xuPWvQ2isSG4CQVzzQM0CGxW+KHKYj31hIEHZI2rB/g=";
    x86_64-darwin = "sha256-omsqaCM+1sPu4AG59oOgYwQBpEJ7irjvTHIo62GVCoE=";
    x86_64-linux = "sha256-fPbI6np3wDqS/OGi2GikgsyMtIVHhxcl+D9lnLd0vos=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "tailwindcss";
  version = "3.4.5";

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
