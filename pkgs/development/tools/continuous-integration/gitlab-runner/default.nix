{ lib, buildGoPackage, fetchFromGitLab, fetchurl, go-bindata }:

let
  version = "1.10.4";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v${version}/docker/prebuilt-x86_64.tar.xz";
    sha256 = "0csaacghcdnkrpxiwsg8166nmdpnddf77c619i558vj0wdglq45k";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v${version}/docker/prebuilt-arm.tar.xz";
    sha256 = "1lsdp4v92v406qiwr435ym4f3zbc1vq6ipwrp7li640frhr2jqpk";
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
    sha256 = "0r8f1m9f544ikcknvq1500kfjxbikgqlv7wdayfpazvj6s1zlswg";
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
