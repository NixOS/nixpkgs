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
    x86_64-linux = "194akxb692xpqppakw49aywp5ma43yfcwv5imw4pm05cna0n06b1";
    x86_64-darwin = "0bgjx54c00v0nb88rzdv09g92yw9qsf2fxd8565g6fsw591va1pa";
    aarch64-linux = "0z07aikjhk9055apbvyaxdp8cgjl291fqgwgfbp9y3826q7s0riq";
    aarch64-darwin = "0garlx458jy6dpqbfd0y2p7xj9hagm815cflybbbxf5yz2v9da01";
  }.${system} or throwSystem;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "infisical";
    version = "0.3.7";

    src = fetchurl {
      url = "https://github.com/Infisical/infisical/releases/download/v${finalAttrs.version}/infisical_${finalAttrs.version}_${plat}.tar.gz";
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
      maintainers = [ maintainers.ivanmoreau ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
    };
  })
