{ substituteAll
, perlPackages
, shadow
, utillinux
, configurationDirectory ? "/etc/nixos-containers"
, stateDirectory ? "/var/lib/nixos-containers"
}:

substituteAll {
    name = "nixos-container";
    dir = "bin";
    isExecutable = true;
    src = ./nixos-container.pl;
    perl = "${perlPackages.perl}/bin/perl -I${perlPackages.FileSlurp}/${perlPackages.perl.libPrefix}";
    su = "${shadow.su}/bin/su";
    inherit utillinux;

    inherit configurationDirectory stateDirectory;

    postInstall = ''
      t=$out/etc/bash_completion.d
      mkdir -p $t
      cp ${./nixos-container-completion.sh} $t/nixos-container
    '';
}
