{ pkgs ? import ./../../../default.nix {}, configuration }:

with pkgs.lib;

let
  config = (evalModules {
    modules = [configuration] ++ (import ./module-list.nix);
    args = { inherit pkgs; };
  }).config;

  #dockerimage = pkgs.stdenv.mkDerivation {
    #name = "docker-base-container";

    #rootfs = import ../../../nixos/lib/make-system-tarball.nix {
      #inherit (pkgs) stdenv perl xz pathsFromGraph;

      #contents = [];
      #extraArgs = "--owner=0";

      #storeContents = (flatten (mapAttrsToList (name: instance:
        #[{ object = instance.entrypoint;
          #symlink = "none";
        #}
        #{ object = instance.entrypoint;
          #symlink = "/init";
        #}]
      #) (config.sal.docker.containers))) ++ [
        #{ object = pkgs.stdenv.shell;
          #symlink = "/bin/bash";
        #}
      #];
    #};

    #dockerfile = pkgs.writeText "base-dockerfile" ''
      #FROM scratch
      #ADD rootfs.tar /
    #'';

    #buildCommand = ''
      #mkdir -p $out && cd $out
      #echo $rootfs
      #xz -kcd $rootfs/tarball/*.tar.xz > rootfs.tar
      #cp $dockerfile Dockerfile
    #'';
  #};

  #mkDockerfile = config: pkgs.writeText "docker-${config.name}-dockerfile" ''
    #FROM scratch
    #${optionalString (config.expose != [])
      #"EXPOSE ${concatMapStringsSep " " (port: toString port) config.expose}"
    #}
    #${concatStringsSep "\n" (map (volume:
      #"VOLUME ${volume.volumePath}"
    #) config.volumes)}
    #ENTRYPOINT ["${config.entrypoint}"]
  #'';

  instance = container: ''
    ${container.name}:
      image: scratch
      ${optionalString (container.links!=[]) ''links:
        ${concatMapStringsSep "\n" (c: "- ${c}") container.links}''}
      ${optionalString (container.ports!=[]) ''ports:
        ${concatMapStringsSep "\n" (c: ''- "${toString p.containerPort}:${toString p.bindPort}'') container.ports}''}
      entrypoint: ${container.entrypoint}
      volumes:
        - /nix/store:/nix/store
  '';

in pkgs.stdenv.mkDerivation {
  name = "docker-image";

  buildCommand = config.assertions.check config.warnings.print ''
    cp ${pkgs.writeText "docker-yml"
    (concatStrings (mapAttrsToList (name: container:
      "${instance container}"
    ) config.sal.docker.containers))} $out
  '';
}
