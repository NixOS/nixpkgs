{ lib
, stdenv
, fetchzip
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "macOS-x64";
    # Balena only packages for x86 so we rely on Rosetta for Apple Silicon
    aarch64-darwin = "macOS-x64";
    x86_64-windows = "windows-x64";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-linux = "0gxki6w8p7ihv0zy02978hg8i242algiw0wpcajrvbx1ncbcb7yn";
    x86_64-darwin = "1ihxyf35px3s6q2yk4p3dy03rcj93hy96bj3pxqlv0rp05gnsf02";
    aarch64-darwin = "1ihxyf35px3s6q2yk4p3dy03rcj93hy96bj3pxqlv0rp05gnsf02";
    x86_64-windows = "104hc3qvs04l2hmjmp0bcjr5g5scp4frhprk1fpszziqhdmhwa40";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "balena-cli";
  version = "15.1.1";

  src = fetchzip {
    url = "https://github.com/balena-io/balena-cli/releases/download/v${version}/balena-cli-v${version}-${plat}-standalone.zip";
    inherit sha256;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r ./* $out/

    ln -s $out/balena $out/bin/balena

    runHook postInstall
  '';

  meta = with lib; {
    description = "A command line interface for balenaCloud or openBalena";
    longDescription = ''
      The balena CLI is a Command Line Interface for balenaCloud or openBalena. It is a software
      tool available for Windows, macOS and Linux, used through a command prompt / terminal window.
      It can be used interactively or invoked in scripts. The balena CLI builds on the balena API
      and the balena SDK, and can also be directly imported in Node.js applications.
    '';
    homepage = "https://github.com/balena-io/balena-cli";
    changelog = "https://github.com/balena-io/balena-cli/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ maintainers.kalebpace ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.cygwin ++ platforms.windows;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "balena";
  };
}
