{
  buildEnv,
  buildGoPackage,
  callPackage,
  dockerTools,
  fetchFromGitHub,
  fly,
  pkgs,
  runCommand,
  stdenv,
}:
let
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "concourse-pipeline-resource";
    rev = "v${version}";
    sha256 = "00pv4srqhh8sip4cahhvgs07xfi7cps66jyp1ri0b4nn7vkwlng2";
  };

  concourse-pipeline-resource = buildGoPackage {
    name = "concourse-pipeline-resource";
    inherit src version;
    goPackagePath = "github.com/concourse/concourse-pipeline-resource";
    subPackages = [ "cmd/in" "cmd/out" "cmd/check" ];
    goDeps = ./deps.nix;
    patches = [ ./fly.patch ];
  };

  env = buildEnv {
    name = "system-path";
    ignoreCollisions = true;
    paths = with pkgs; [
      bashInteractive
      cacert
      tzdata
      fly
    ];
    postBuild = ''
      mkdir -p $out/opt/resource
      pushd $out
        ln -st opt/resource/ ${concourse-pipeline-resource}/bin/*
      popd
    '';
  };

  image =
    dockerTools.buildImageWithNixDb {
      name = "concourse-pipeline-resource";
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
    "concourse-pipeline-resource-dir"
    {
      metadata = builtins.toJSON {
        type = "concourse-pipeline";
        inherit version;
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
