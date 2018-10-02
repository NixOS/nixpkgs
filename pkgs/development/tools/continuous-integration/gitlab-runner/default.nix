{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "11.3.1";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-x86_64.tar.xz";
    sha256 = "13w8fjjc087klracv4ggjifj08vx3b549mhy220r5wn9aga5m549";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-arm.tar.xz";
    sha256 = "10s2g6mqy7p5dmjmlxggsfqqqf4bfrqjri7m2nd11l1lf4mmr2kk";
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
    sha256 = "1k978zsvsvr7ys18zqjg6n45cwi3nj0919fwj442dv99s95zyf6s";
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
    maintainers = with maintainers; [ bachp zimbatm ];
  };
}
