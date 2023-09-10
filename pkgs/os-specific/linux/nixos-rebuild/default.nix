{ substituteAll
, runtimeShell
, coreutils
, gnused
, gnugrep
, nix
, lib
, nixosTests
, installShellFiles
}:
let
  fallback = import ./../../../../nixos/modules/installer/tools/nix-fallback-paths.nix;
in
substituteAll {
  name = "nixos-rebuild";
  src = ./nixos-rebuild.sh;
  dir = "bin";
  isExecutable = true;
  inherit runtimeShell nix;
  nix_x86_64_linux = fallback.x86_64-linux;
  nix_i686_linux = fallback.i686-linux;
  nix_aarch64_linux = fallback.aarch64-linux;
  path = lib.makeBinPath [ coreutils gnused gnugrep ];
  nativeBuildInputs = [
    installShellFiles
  ];
  postInstall = ''
    installManPage ${./nixos-rebuild.8}
  '';

  # run some a simple installer tests to make sure nixos-rebuild still works for them
  passthru.tests = {
    simple-installer = nixosTests.installer.simple;
    specialisations = nixosTests.nixos-rebuild-specialisations;
  };

  meta = {
    description = "Rebuild your NixOS configuration and switch to it, on local hosts and remote.";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/os-specific/linux/nixos-rebuild";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Profpatsch ];
    mainProgram = "nixos-rebuild";
  };
}
