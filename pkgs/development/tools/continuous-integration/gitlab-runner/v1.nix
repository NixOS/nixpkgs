{ lib, buildGoPackage, fetchFromGitLab, fetchurl, go-bindata }:

let
  version = "1.11.2";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v${version}/docker/prebuilt-x86_64.tar.xz";
    sha256 = "08lacd2p7915y7yjnwkj2k0b0x4qj9kc53p7qgvmq8kdi31xnh4z";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v${version}/docker/prebuilt-arm.tar.xz";
    sha256 = "0lzvx3jfy8493q8zkbs7kgm5a3jgsi3f2x25jwg4lx7agcwwsygw";
  };
in
buildGoPackage rec {
  inherit version;
  name = "gitlab-runner-${version}";
  goPackagePath = "gitlab.com/gitlab-org/gitlab-ci-multi-runner";
  commonPackagePath = "${goPackagePath}/common";
  buildFlagsArray = ''
    -ldflags=
      -X ${commonPackagePath}.NAME=gitlab-runner
      -X ${commonPackagePath}.VERSION=${version}
      -X ${commonPackagePath}.REVISION=v${version}
  '';

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-ci-multi-runner";
    rev = "v${version}";
    sha256 = "1sjvlb5981ykc8hr4kp1ibh9jw2wdjjp9zs2nqs9lpsav4nda5fr";
  };

  buildInputs = [ go-bindata ];

  preBuild = ''
    (
    # go-bindata names the assets after the filename thus we create a symlink with the name we want
    cd go/src/${goPackagePath}
    ln -sf ${docker_x86_64} prebuilt-x86_64.tar.xz
    ln -sf ${docker_arm} prebuilt-arm.tar.xz
    go-bindata \
        -pkg docker \
        -nocompress \
        -nomemcopy \
        -o executors/docker/bindata.go \
        prebuilt-x86_64.tar.xz \
        prebuilt-arm.tar.xz
    )
  '';

  postInstall = ''
    install -d $out/bin
    # The recommended name is gitlab-runner so we create a symlink with that name
    ln -sf gitlab-ci-multi-runner $bin/bin/gitlab-runner
  '';

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = "https://about.gitlab.com/gitlab-ci/";
    platforms = platforms.unix;
    maintainers = [ lib.maintainers.bachp ];
  };
}
