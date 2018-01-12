{ lib, bundlerEnv, ruby_2_2, stdenv, makeWrapper }:

stdenv.mkDerivation rec {
  name = "rhc-1.38.7";

  env = bundlerEnv {
    name = "rhc-1.38.7-gems";

    ruby = ruby_2_2;

    gemdir = ./.;
  };

  buildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/rhc $out/bin/rhc
  '';

  meta = with lib; {
    homepage = https://github.com/openshift/rhc;
    description = "OpenShift client tools";
    license = licenses.asl20;
    maintainers = [ maintainers.szczyp ];
  };
}
