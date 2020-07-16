{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "13.1.0";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-x86_64.tar.xz";
    sha256 = "1x44vbfcmk95rjkhmfizfdmr1blyj7x1a84hdynrgcyg69m6zikn";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-arm.tar.xz";
    sha256 = "08n3nrpwhb3d3znid2bibg54qxdw5z6r4j5fp8vjh33h45q47q0k";
  };
in
buildGoPackage rec {
  inherit version;
  pname = "gitlab-runner";
  goPackagePath = "gitlab.com/gitlab-org/gitlab-runner";
  subPackages = [ "." ];
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
    sha256 = "0mbcpz1i0jmx5y67cvjwaizbj6jxdqml5m4m42dx96jqk0bv8g55";
  };

  patches = [ ./fix-shell-path.patch ];

  postInstall = ''
    install -d $out/bin/helper-images
    ln -sf ${docker_x86_64} $out/bin/helper-images/prebuilt-x86_64.tar.xz
    ln -sf ${docker_arm} $out/bin/helper-images/prebuilt-arm.tar.xz
  '';

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = "https://about.gitlab.com/gitlab-ci/";
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ bachp zimbatm globin ];
  };
}
