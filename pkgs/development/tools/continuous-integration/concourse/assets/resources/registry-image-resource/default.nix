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
  version = "0.1.1";
  registry-image-resource = buildGoPackage {
    name = "registry-image-resource";
    goPackagePath = "github.com/concourse/registry-image-resource";
    goDeps = ./deps.nix;
    src = fetchFromGitHub {
      owner = "concourse";
      repo = "registry-image-resource";
      rev = "v${version}";
      sha256 = "134fqvvcyldhpkv38f0anlrmplmsz0if71fvmgzm1d0wi5lxg9za";
    };
  };

  env = buildEnv {
    name = "system-path";
    ignoreCollisions = true;
    paths = with pkgs; [ bashInteractive cacert unzip zip gnutar tzdata ];
    postBuild = ''
      mkdir -p $out/opt
      ln -s ${registry-image-resource}/bin $out/opt/resource
    '';
  };

  image =
    dockerTools.buildImage {
      name = "registry-image-resource";
      tag = "latest";
      contents = env;
      config.Env = [
        "PATH=/bin"
        "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ];
    };

  dir =
    runCommand
    "registry-image-resource-dir"
    {
      metadata = builtins.toJSON {
        type = "registry-image";
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
  inherit dir version;
}
