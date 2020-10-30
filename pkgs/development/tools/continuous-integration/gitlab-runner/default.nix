{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "13.5.0";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-x86_64.tar.xz";
    sha256 = "1cahv98hhwcc0czg7c86sqk0r6kw3gxnx8j6mqp1zm19aa30sabk";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-arm.tar.xz";
    sha256 = "1wk7xn8jap8699cpgqkpgxmd908qjxlsfjswknrha1n8y2c5bjgx";
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
    sha256 = "0qfzdbhj68lq5pa1hvb703yx9grh3hvnnw6jb4bj4fckncd3avgm";
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
