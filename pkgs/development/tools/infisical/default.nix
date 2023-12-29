{ stdenv, lib, fetchurl, testers, infisical, installShellFiles }:

# this expression is mostly automated, and you are STRONGLY
# RECOMMENDED to use to nix-update for updating this expression when new
# releases come out, which runs the sibling `update.sh` script.
#
# from the root of the nixpkgs git repository, run:
#
#    nix-shell maintainers/scripts/update.nix \
#      --argstr commit true \
#      --argstr package infisical

let
  # build hashes, which correspond to the hashes of the precompiled binaries procured by GitHub Actions.
  buildHashes = builtins.fromJSON (builtins.readFile ./hashes.json);

  # the version of infisical
  version = "0.16.3";

  # the platform-specific, statically linked binary
  src =
    let
      suffix = {
        # map the platform name to the golang toolchain suffix
        # NOTE: must be synchronized with update.sh!
        x86_64-linux = "linux_amd64";
        x86_64-darwin = "darwin_amd64";
        aarch64-linux = "linux_arm64";
        aarch64-darwin = "darwin_arm64";
      }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

      name = "infisical_${version}_${suffix}.tar.gz";
      hash = buildHashes."${stdenv.hostPlatform.system}";
      url = "https://github.com/Infisical/infisical/releases/download/infisical-cli%2Fv${version}/${name}";
    in
    fetchurl { inherit name url hash; };

in
stdenv.mkDerivation {
  pname = "infisical";
  version = version;
  inherit src;

  nativeBuildInputs = [ installShellFiles ];

  doCheck = true;
  dontConfigure = true;
  dontStrip = true;

  sourceRoot = ".";
  buildPhase = "chmod +x ./infisical";
  checkPhase = "./infisical --version";
  installPhase = ''
    mkdir -p $out/bin/ $out/share/completions/ $out/share/man/
    cp infisical $out/bin
    cp completions/* $out/share/completions/
    cp manpages/* $out/share/man/
  '';
  postInstall = ''
    installManPage share/man/infisical.1.gz
    installShellCompletion share/completions/infisical.{bash,fish,zsh}
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion { package = infisical; };
  };

  meta = with lib; {
    description = "The official Infisical CLI";
    longDescription = ''
      Infisical is the open-source secret management platform:
      Sync secrets across your team/infrastructure and prevent secret leaks.
    '';
    homepage = "https://infisical.com";
    changelog = "https://github.com/infisical/infisical/releases/tag/infisical-cli%2Fv${version}";
    license = licenses.mit;
    mainProgram = "infisical";
    maintainers = [ maintainers.ivanmoreau maintainers.jgoux ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
