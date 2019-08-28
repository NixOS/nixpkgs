{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "12.2.0";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-x86_64.tar.xz";
    sha256 = "0r0jy571dxcspsl0q31wyw4017rfq7i4rxsgf83jqdjqaigas8dk";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-arm.tar.xz";
    sha256 = "1pbzyfvfgwp9r67a148nr4gh2p9lrmnn4hxap37abb5q5209pjir";
  };
in
buildGoPackage rec {
  inherit version;
  pname = "gitlab-runner";
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
    sha256 = "0id0ivysn0396dwi357iig28d4xr2wd7q05r6ksgml8xyfijdgd3";
  };

  patches = [ ./fix-shell-path.patch ];

  postInstall = ''
    touch $bin/bin/hello
    install -d $bin/bin/helper-images
    ln -sf ${docker_x86_64} $bin/bin/helper-images/prebuilt-x86_64.tar.xz
    ln -sf ${docker_arm} $bin/bin/helper-images/prebuilt-arm.tar.xz
  '';

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = https://about.gitlab.com/gitlab-ci/;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ bachp zimbatm globin ];
  };
}
