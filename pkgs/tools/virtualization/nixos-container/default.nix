{ substituteAll
, perl
, shadow
, util-linux
, configurationDirectory ? "/etc/nixos-containers"
, stateDirectory ? "/var/lib/nixos-containers"
, nixosTests
}:

substituteAll {
    name = "nixos-container";
    dir = "bin";
    isExecutable = true;
    src = ./nixos-container.pl;
    perl = perl.withPackages (p: [ p.FileSlurp ]);
    su = "${shadow.su}/bin/su";
    utillinux = util-linux;

    inherit configurationDirectory stateDirectory;

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
