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
  version = "1.0.0";

  src =
  let
    src = fetchFromGitHub {
      owner = "concourse";
      repo = "docker-image-resource";
      rev = "v${version}";
      sha256 = "1yfxwc9n1b2j0324n1fn9lyvly93jc6s1v3mlljbrkjpm9kl8izg";
    };
  in
    stdenv.mkDerivation {
      name = "patched-docker-image-resource";
      inherit src;
      patches = [ ./timeout.patch ];
      installPhase = ''
        mkdir -p $out
        cp -a ./. $out/
      '';
    };

  docker-image-resource = buildGoPackage {
    name = "docker-image-resource";
    inherit src;
    goPackagePath = "github.com/concourse/docker-image-resource";
    subPackages = [
      "cmd/check"
      "cmd/print-metadata"
      "vendor/github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cmd"
    ];
    goDeps = ./deps.nix;
  };

  env = buildEnv {
    name = "system-path";
    ignoreCollisions = true;
    paths = with pkgs; [
      bashInteractive
      cacert
      coreutils
      docker
      gawk
      gnugrep
      gnused
      gnutar
      iproute
      jq
      utillinux
      xz
    ];
    postBuild = ''
      mkdir -p $out/opt/resource
      pushd $out
        ln -st opt/resource/ ${docker-image-resource}/bin/*
        cp -R ${src}/assets/. opt/resource/
        ln -s ${docker-image-resource}/bin/cmd opt/resource/ecr-login
        ln -s ${docker-image-resource}/bin/cmd bin/docker-credential-ecr-login
      popd
    '';
  };

  image =
    dockerTools.buildImage {
      name = "docker-image-resource";
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
    "docker-image-resource-dir"
    {
      metadata = builtins.toJSON {
        type = "docker-image";
        inherit version;
        privileged = true;
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
