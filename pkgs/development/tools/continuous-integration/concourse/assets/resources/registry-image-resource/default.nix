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
  version = "0.2.0";
  registry-image-resource = buildGoPackage {
    name = "registry-image-resource";
    goPackagePath = "github.com/concourse/registry-image-resource";
    goDeps = ./deps.nix;
    src = fetchFromGitHub {
      owner = "concourse";
      repo = "registry-image-resource";
      rev = "v${version}";
      sha256 = "0sz5ig1f1297ma3yi7fc3p4jmn9wm2svnlv2j1l2j5zpv0nqpjx2";
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
      extraCommands = ''
        chmod +w etc

        cat >etc/passwd <<EOF
        root:x:0:0::/root:/bin/sh
        EOF
        cat >etc/group <<EOF
        root:x:0:
        EOF
        cat >etc/nsswitch.conf <<EOF
        hosts: files dns
        EOF
      '';
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
