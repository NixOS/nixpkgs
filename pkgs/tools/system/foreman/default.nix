{ stdenv, lib, ruby, bundlerEnv, makeWrapper }:

stdenv.mkDerivation rec {
  name = "foreman-${env.gems.foreman.version}";

  env = bundlerEnv {
    inherit ruby;
    name = "${name}-gems";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  phases = ["installPhase"];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/foreman $out/bin/foreman
  '';

  meta = with lib; {
    description = "Process manager for applications with multiple components";
    homepage = https://github.com/ddollar/foreman;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = ruby.meta.platforms;
  };
}
