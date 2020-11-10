{ substituteAll, perlPackages, shadow, utillinux }:

substituteAll {
    name = "nixos-container";
    dir = "bin";
    isExecutable = true;
    src = ./nixos-container.pl;
    perl = "${perlPackages.perl}/bin/perl -I${perlPackages.FileSlurp}/${perlPackages.perl.libPrefix}";
    su = "${shadow.su}/bin/su";
    inherit utillinux;

    postInstall = ''
      t=$out/share/bash-completion/completions
      mkdir -p $t
      cp ${./nixos-container-completion.sh} $t/nixos-container
    '';
}
