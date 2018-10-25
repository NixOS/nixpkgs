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
    repo = "git-resource";
    rev = "v${version}";
    sha256 = "1nhzk9mxawzvdwk601ykllwhalfc64hpfva1x2v3xsacsgn3zvym";
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
      git
      git-crypt
      git-lfs
      gnupg
      gnused
      gnutar
      gzip
      jq
      openssh
      proxytunnel
      xz
    ];
    postBuild = ''
      mkdir -p $out/root $out/opt/resource
      cp -a ${src}/assets/. $out/opt/resource/

      cat >$out/etc/gitconfig <<EOF
      [user]
        email = git@localhost
        name = git
      [http]
        sslcainfo = ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      EOF
    '';
  };

  image =
    dockerTools.buildImage {
      name = "git-resource";
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
    "git-resource-dir"
    {
      metadata = builtins.toJSON {
        type = "git";
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
