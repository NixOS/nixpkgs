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
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "concourse";
    repo = "github-release-resource";
    rev = "v${version}";
    sha256 = "0zb0lcl9rrj4zai0w709cv0c7mpmyc68c2q1qbh6nfsm3r55d7nb";
  };
  github-release-resource = buildGoPackage {
    name = "docker-image-resource";
    inherit src;
    goPackagePath = "github.com/concourse/github-release-resource";
    goDeps = ./deps.nix;
  };
  env = buildEnv {
    name = "system-path";
    ignoreCollisions = true;
    paths = with pkgs; [
      cacert
      tzdata
    ];
    postBuild = ''
      mkdir -p $out/opt/resource
      cp -a ${github-release-resource}/bin/. $out/opt/resource/
    '';
  };

  image =
    dockerTools.buildImage {
      name = "github-release-resource";
      tag = "latest";
      contents = env;
      config.Env = [
        "PATH=/bin"
        "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ];
      extraCommands = ''
        chmod +w etc

        cat >etc/nsswitch.conf <<EOF
        hosts: files dns
        EOF
      '';
    };

  dir =
    runCommand
    "github-release-resource-dir"
    {
      metadata = builtins.toJSON {
        type = "github-release";
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
