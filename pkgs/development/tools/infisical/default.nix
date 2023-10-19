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
    x86_64-linux = "e85c5f2ddca89caa6b44c61554c1dffeacdabc96c25a7e6881dc5722515270d1";
    x86_64-darwin = "eddbcde10271f791eb1473ba00b85b442aa059cdfee38021b8f8880f33754821";
    aarch64-linux = "9793a6db476492802ffec7f933d7f8f107a1c89fee09c8eb6bdb975b1fccecea";
    aarch64-darwin = "46c8a82a71da5731c108d24b4a960a507af66d91bba7b7246dd3a3415afaf7d3";
  }.${system} or throwSystem;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "infisical";
    version = "0.14.2";

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
