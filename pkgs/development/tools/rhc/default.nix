{ lib, bundlerEnv, ruby, stdenv, makeWrapper }:

stdenv.mkDerivation rec {
  name = "rhc-1.38.7";

  env = bundlerEnv {
    name = "rhc-1.38.7-gems";

    inherit ruby;

    gemdir = ./.;
  };

  buildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/rhc $out/bin/rhc
  '';

  meta = with lib; {
    broken = true; # requires ruby 2.2
    homepage = https://github.com/openshift/rhc;
    description = "OpenShift client tools";
    license = licenses.asl20;
    maintainers = [ maintainers.szczyp ];
  };
}
