{ stdenv, lib, bundlerEnv, makeWrapper, git, gnutar, gzip, ruby }:

stdenv.mkDerivation rec {
  name = "r10k-${version}";

  version = "2.4.3";

  env = bundlerEnv {
    name = "${name}-gems";

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    inherit ruby;
  };

  phases = ["installPhase"];

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/r10k $out/bin/r10k \
      --set PATH ${stdenv.lib.makeBinPath [ git gnutar gzip ]}
  '';

  meta = with lib; {
    description = "Puppet environment and module deployment";
    homepage    = https://github.com/puppetlabs/r10k;
    license     = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
