{ lib, buildGoPackage, fetchFromGitLab, fetchurl, go-bindata }:

let
  version = "10.8.0";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/docker/prebuilt-x86_64.tar.xz";
    sha256 = "1cdc0p3gq6q324p087qv335y224bv61fbr8xar4kza7lcqblb41d";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/docker/prebuilt-arm.tar.xz";
    sha256 = "0xj0ym6mprrknxqrxqj3ydgabqgfdxrw3h1r0q8sggfxqrrs8y08";
  };
in
buildGoPackage rec {
  inherit version;
  name = "gitlab-runner-${version}";
  goPackagePath = "gitlab.com/gitlab-org/gitlab-runner";
  commonPackagePath = "${goPackagePath}/common";
  buildFlagsArray = ''
    -ldflags=
      -X ${commonPackagePath}.NAME=gitlab-runner
      -X ${commonPackagePath}.VERSION=${version}
      -X ${commonPackagePath}.REVISION=v${version}
  '';

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    rev = "v${version}";
    sha256 = "0j8xkwfxvmg1bqrmalqvl6k45yn54m16r3af5ckgr717xylywqb6";
  };

  patches = [ ./fix-shell-path.patch ];

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
  '';

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = https://about.gitlab.com/gitlab-ci/;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ bachp zimbatm ];
  };
}
