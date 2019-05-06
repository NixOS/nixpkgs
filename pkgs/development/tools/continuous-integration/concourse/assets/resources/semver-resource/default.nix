{
  buildEnv,
  buildGoPackage,
  callPackage,
  dockerTools,
  fetchFromGitHub,
  pkgs,
  runCommand,
  stdenv,
}:
let
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "concourse";
    repo = "semver-resource";
    rev = "v${version}";
    sha256 = "1si772s5fzmv2m6q67i3b7x2lc27w8n3dcwimjdk0x8d26lfll31";
  };

  semver-resource = buildGoPackage {
    name = "semver-resource";
    inherit src version;
    goPackagePath = "github.com/concourse/semver-resource";
    subPackages = [ "in" "out" "check" ];
    goDeps = ./deps.nix;
  };

  env = buildEnv {
    name = "system-path";
    ignoreCollisions = true;
    paths = with pkgs; [
      bashInteractive
      cacert
      git
      jq
      openssh
      tzdata
    ];
    postBuild = ''
      mkdir -p $out/opt/resource
      pushd $out
        ln -st opt/resource/ ${semver-resource}/bin/*
      popd
    '';
  };

  image =
    dockerTools.buildImageWithNixDb {
      name = "semver-resource";
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
    "semver-resource-dir"
    {
      metadata = builtins.toJSON {
        type = "semver";
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
