{ name, pkgs ? import ./../../../default.nix {}, configuration }:

with pkgs.lib;

let
  supervisor = pkgs.pythonPackages.supervisor;

  config = (evalModules {
    modules = [
      configuration ./module.nix
      {
        sal.processManager.supports.privileged = false;
        sal.supervisor.unprivilegedUser = "nobody";
        sal.supervisor.stateDir = "/tmp/services";
      }
    ];
    args = { inherit pkgs; };
  }).config;

  supervisordWrapper = pkgs.writeScript "supervisord-wrapper" ''
    #!${pkgs.stdenv.shell} -e
    extraFlags=""
    if [ -n "$STATEDIR" ]; then
      extraFlags="-j $STATEDIR/run/supervisord.pid -d $STATEDIR -q $STATEDIR/log/ -l $STATEDIR/log/supervisord.log"
      mkdir -p "$STATEDIR"/{run,log}
    else
      mkdir -p "${config.sal.supervisor.stateDir}"/{run,log}
    fi

    cp ${config.sal.supervisor.config} "${config.sal.supervisor.stateDir}/supervisord.conf"
    chmod +w "${config.sal.supervisor.stateDir}/supervisord.conf"

    # Run supervisord
    exec ${supervisor}/bin/supervisord -c "${config.sal.supervisor.stateDir}/supervisord.conf" $extraFlags "$@"
  '';

  supervisorctlWrapper = pkgs.writeScript "supervisorctl-wrapper" ''
    #!${pkgs.stdenv.shell}
    cp ${config.sal.supervisor.config} "${config.sal.supervisor.stateDir}/supervisord.conf"
    chmod +w "${config.sal.supervisor.stateDir}/supervisord.conf"
    exec ${supervisor}/bin/supervisorctl -c "${config.sal.supervisor.stateDir}/supervisord.conf" "$@"
  '';

  stopServices = pkgs.writeScript "stopServices" ''
    #!${pkgs.stdenv.shell}
    ${supervisorctlWrapper} shutdown
  '';

  updateServices = pkgs.writeScript "updateServices" ''
    #!${pkgs.stdenv.shell}
    ${supervisorctlWrapper} update
  '';

  servicesControl  = pkgs.stdenv.mkDerivation {
    name = "${name}-servicesControl";

    phases = [ "installPhase" ];

    installPhase = config.assertions.check (config.warnings.print ''
      mkdir -p $out/bin/
      ln -s ${supervisordWrapper} $out/bin/${name}-start-services
      ln -s ${stopServices} $out/bin/${name}-stop-services
      ln -s ${updateServices} $out/bin/${name}-update-services
      ln -s ${supervisorctlWrapper} $out/bin/${name}-control-services
    '');
  };

  systemPackages = pkgs.runCommand "${name}-system-packages" {} ''
    mkdir -p $out
    ln -s ${pkgs.buildEnv {
      name = "${name}-system-packages-env";
      paths = config.environment.systemPackages;
    }}/{bin,sbin} $out/
  '';

in pkgs.buildEnv {
  name = "${name}-services";
  paths = [ servicesControl systemPackages ];
}
