{ lib, bundlerEnv, ruby, wrapCommand }:

let
  env = bundlerEnv {
    name = "rhc-gems";
    inherit ruby;
    gemdir = ./.;
  };
in wrapCommand "rhc" {
  inherit (env.gems.rhc) version;
  executable = "${env}/bin/rhc";
  meta = with lib; {
    homepage = https://github.com/openshift/rhc;
    description = "OpenShift client tools";
    license = licenses.asl20;
    maintainers = [ maintainers.szczyp ];
  };
}
