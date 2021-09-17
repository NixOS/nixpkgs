{ substituteAll, perl, shadow, util-linux }:

substituteAll {
    name = "nixos-container";
    dir = "bin";
    isExecutable = true;
    src = ./nixos-container.pl;
    perl = perl.withPackages (p: [ p.FileSlurp ]);
    su = "${shadow.su}/bin/su";
    utillinux = util-linux;

    postInstall = ''
      t=$out/share/bash-completion/completions
      mkdir -p $t
      cp ${./nixos-container-completion.sh} $t/nixos-container
    '';
}
