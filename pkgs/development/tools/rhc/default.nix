{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "rhc-1.36.4";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    homepage = https://github.com/openshift/rhc;
    description = "OpenShift client tools";
    license = licenses.asl20;
    maintaners = maintainers.szczyp;
  };
}
