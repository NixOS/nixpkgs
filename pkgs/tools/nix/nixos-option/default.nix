{ lib
, runtimeShell
, substitute
, installShellFiles
, nix
, jq
}:

substitute {
  name = "nixos-option";
  src = ./nixos-option.sh;
  dir = "bin";
  isExecutable = true;

  substitutions = [
    "--subst-var-by" "runtimeShell" runtimeShell
    "--subst-var-by" "nixInstantiate" "${nix}/bin/nix-instantiate"
    "--subst-var-by" "nixosOptionNix" "${./nixos-option.nix}"
    "--subst-var-by" "nixosOptionManpage" "${placeholder "out"}/share/man/man8/nixos-option.8"
    "--subst-var-by" "jq" "${jq}/bin/jq"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage ${./nixos-option.8}
  '';

  strictDeps = true;

  meta = {
    license = lib.licenses.mit;
    mainProgram = "nixos-option";
    maintainers = [ lib.maintainers.FireyFly ];
  };
}
