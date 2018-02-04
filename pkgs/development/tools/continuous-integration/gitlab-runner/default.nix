{ lib, buildGoPackage, fetchFromGitLab, fetchurl, go-bindata }:

let
  version = "10.4.0";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/docker/prebuilt-x86_64.tar.xz";
    sha256 = "0fcddi1mwgj831abn628zcpwsah3mmvrbdi851pjf8vraynwr2xa";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/docker/prebuilt-arm.tar.xz";
    sha256 = "1zlk3i9jzmsqz5r3kzg08z9hyhidw9dpv5ji46bnbjis8q3dlw54";
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
    sha256 = "0kp6h53d1q652i4wp94hydy1ixlgmqh92sjsc6pqicnfc7nvwgfq";
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
