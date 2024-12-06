{ callPackage
, substitute
, runtimeShell
, coreutils
, gnused
, gnugrep
, jq
, util-linux
, nix
, lib
, nixosTests
, installShellFiles
, binlore
, nixos-rebuild
}:
let
  fallback = import ./../../../../nixos/modules/installer/tools/nix-fallback-paths.nix;
in
substitute {
  name = "nixos-rebuild";
  src = ./nixos-rebuild.sh;
  dir = "bin";
  isExecutable = true;

  substitutions = [
    "--subst-var-by" "runtimeShell" runtimeShell
    "--subst-var-by" "nix" nix
    "--subst-var-by" "nix_x86_64_linux" fallback.x86_64-linux
    "--subst-var-by" "nix_i686_linux" fallback.i686-linux
    "--subst-var-by" "nix_aarch64_linux" fallback.aarch64-linux
    "--subst-var-by" "path" (lib.makeBinPath [ coreutils gnused gnugrep jq util-linux ])
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage ${./nixos-rebuild.8}

    installShellCompletion \
      --bash ${./_nixos-rebuild}
  '';

  # run some a simple installer tests to make sure nixos-rebuild still works for them
  passthru.tests = {
    install-bootloader = nixosTests.nixos-rebuild-install-bootloader;
    repl = callPackage ./test/repl.nix {};
    simple-installer = nixosTests.installer.simple;
    specialisations = nixosTests.nixos-rebuild-specialisations;
    target-host = nixosTests.nixos-rebuild-target-host;
  };

  # nixos-rebuild can’t execute its arguments
  # (but it can run ssh with the with the options stored in $NIX_SSHOPTS,
  # and ssh can execute its arguments...)
  passthru.binlore.out = binlore.synthesize nixos-rebuild ''
    execer cannot bin/nixos-rebuild
  '';

  meta = {
    description = "Rebuild your NixOS configuration and switch to it, on local hosts and remote";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/os-specific/linux/nixos-rebuild";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Profpatsch thiagokokada ];
    mainProgram = "nixos-rebuild";
  };
}
