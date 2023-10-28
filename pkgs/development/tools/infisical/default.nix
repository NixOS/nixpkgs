{ stdenv, lib, callPackage, fetchurl }:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux_amd64";
    x86_64-darwin = "darwin_amd64";
    aarch64-linux = "linux_arm64";
    aarch64-darwin = "darwin_arm64";
  }.${system} or throwSystem;

  archive_fmt = "tar.gz";

  sha256 = {
    x86_64-linux = "b137f0a2830de5c91d6b1a5de11df242f0c4613ee6b98653c85126d1ec4cdf73";
    x86_64-darwin = "07de3e985e56bb4a47288a3c0ae1c06eba2bcc8c4ad94eb8369dc91654dcd649";
    aarch64-linux = "786b8a9c2ea1d583d6d14758e7070285b892cc04c071298767a98a048dac47cd";
    aarch64-darwin = "b38b3595ad7ae5c439236f7a642796dd923261aa537d1c5adb441d6665ef89da";
  }.${system} or throwSystem;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "infisical";
    version = "0.14.3";

    src = fetchurl {
      url = "https://github.com/Infisical/infisical/releases/download/infisical-cli%2Fv${finalAttrs.version}/infisical_${finalAttrs.version}_${plat}.tar.gz";
      inherit sha256;
    };

    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/bin/ $out/share/completions/ $out/share/man/
      cp completions/* $out/share/completions/
      cp manpages/* $out/share/man/
      cp infisical $out/bin
    '';

    postInstall = ''
      installManPage share/man/infisical.1.gz
      installShellCompletion share/completions/infisical.{bash,fish,zsh}
      chmod +x bin/infisical
    '';

    meta = with lib; {
      description = "The official Infisical CLI";
      longDescription = ''
        Infisical is an Open Source, End-to-End encrypted platform that lets you
        securely sync secrets and configs across your team, devices, and infrastructure
      '';
      mainProgram = "infisical";
      homepage = "https://infisical.com/";
      downloadPage = "https://github.com/Infisical/infisical/releases/";
      license = licenses.mit;
      maintainers = [ maintainers.ivanmoreau maintainers.jgoux ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
    };
  })
