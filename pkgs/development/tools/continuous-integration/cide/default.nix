{ stdenv, lib, bundlerEnv, bundlerUpdateScript, makeWrapper, docker, git, gnutar, gzip }:

stdenv.mkDerivation rec {
  name = "cide-${version}";
  version = "0.9.0";

  env = bundlerEnv {
    name = "${name}-gems";

    gemdir = ./.;
  };

  phases = ["installPhase"];

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/cide $out/bin/cide \
      --set PATH ${stdenv.lib.makeBinPath [ docker git gnutar gzip ]}
  '';

  passthru.updateScript = bundlerUpdateScript "cide";

  meta = with lib; {
    description = "Isolated test runner with Docker";
    homepage    = http://zimbatm.github.io/cide/;
    license     = licenses.mit;
    maintainers = with maintainers; [ zimbatm nicknovitski ];
    platforms   = docker.meta.platforms;
  };
}
