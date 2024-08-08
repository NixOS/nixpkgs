{ substitute
, perl
, shadow
, util-linux
, runtimeShell
, configurationDirectory ? "/etc/nixos-containers"
, stateDirectory ? "/var/lib/nixos-containers"
, nixosTests
}:

substitute {
  name = "nixos-container";
  dir = "bin";
  isExecutable = true;
  src = ./nixos-container.pl;

  substitutions = [
    "--subst-var-by" "configurationDirectory" configurationDirectory
    "--subst-var-by" "perl" (perl.withPackages (p: [ p.FileSlurp ]))
    "--subst-var-by" "stateDirectory" stateDirectory
    "--subst-var-by" "su" "${shadow.su}/bin/su"
    "--subst-var-by" "utillinux" util-linux
    "--subst-var-by" "shell" runtimeShell
  ];

  passthru = {
    tests = {
      inherit (nixosTests)
        containers-imperative
        containers-ip
        containers-tmpfs
        containers-ephemeral
        containers-unified-hierarchy
        ;
    };
  };

  postInstall = ''
    t=$out/share/bash-completion/completions
    mkdir -p $t
    cp ${./nixos-container-completion.sh} $t/nixos-container
  '';

  meta.mainProgram = "nixos-container";
}
