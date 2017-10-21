{ substituteAll, perl, perlPackages, shadow, utillinux }:

substituteAll {
    name = "nixos-container";
    dir = "bin";
    isExecutable = true;
    src = ./nixos-container.pl;
    perl = "${perl}/bin/perl -I${perlPackages.FileSlurp}/lib/perl5/site_perl";
    su = "${shadow.su}/bin/su";
    inherit utillinux;

    postInstall = ''
      t=$out/etc/bash_completion.d
      mkdir -p $t
      cp ${./nixos-container-completion.sh} $t/nixos-container
    '';
}
