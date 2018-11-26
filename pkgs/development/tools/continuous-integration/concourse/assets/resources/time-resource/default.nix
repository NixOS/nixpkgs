{
  buildEnv,
  buildGoPackage,
  callPackage,
  dockerTools,
  fetchFromGitHub,
  pkgs,
  runCommand,
}:
let
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "time-resource";
    rev = "v${version}";
    sha256 = "14jmk7rlzvf8s4lfy5znjfqbq6bxavhqwbdw5np0n71ky3k2kjs1";
  };

  time-resource = buildGoPackage {
    name = "time-resource";
    goPackagePath = "github.com/concourse/time-resource";
    inherit src;
    goDeps = ./deps.nix;
  };

  env = buildEnv {
    name = "system-path";
    ignoreCollisions = true;
    paths = with pkgs; [
      tzdata
    ];
    postBuild = ''
      mkdir -p $out/opt
      ln -s ${time-resource}/bin $out/opt/resource
    '';
  };

  image =
    dockerTools.buildImage {
      name = "time-resource";
      tag = "latest";
      contents = env;
      config.Env = [
        "PATH=/bin"
      ];
    };

  dir =
    runCommand
    "time-resource-dir"
    {
      metadata = builtins.toJSON {
        type = "time";
        inherit version;
        privileged = false;
      };
      src = image;
      passAsFile = [ "metadata" ];
    }
    ''
      mkdir -p $out
      tar -xzf $src
      for layer in `find . -name 'layer.tar'`; do
          gzip -c $layer > $out/rootfs.tgz
      done
      cp $metadataPath $out/resource_metadata.json
    '';
in
{
  inherit dir version src;
}
