{ stdenv, lib, bundlerEnv, makeWrapper, docker, git, gnutar, gzip }:

stdenv.mkDerivation rec {
  name = "cide-${version}";
  version = "0.9.0";

  env = bundlerEnv {
    name = "${name}-gems";

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  phases = ["installPhase"];

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/cide $out/bin/cide \
      --set PATH ${stdenv.lib.makeBinPath [ docker git gnutar gzip ]}
  '';

  meta = with lib; {
    description = "Isolated test runner with Docker";
    homepage    = http://zimbatm.github.io/cide/;
    license     = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms   = docker.meta.platforms;
  };
}
