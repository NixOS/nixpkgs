{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "14.5.2";
in
buildGoPackage rec {
  inherit version;
  pname = "gitlab-runner";
  goPackagePath = "gitlab.com/gitlab-org/gitlab-runner";
  subPackages = [ "." ];
  commonPackagePath = "${goPackagePath}/common";
  ldflags = [
    "-X ${commonPackagePath}.NAME=gitlab-runner"
    "-X ${commonPackagePath}.VERSION=${version}"
    "-X ${commonPackagePath}.REVISION=v${version}"
  ];

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    rev = "v${version}";
    sha256 = "07mr9w1rp3rnrlixmqziin1gw78s3gncg47b4z9h9zzpy3acy3xd";
  };

  patches = [
    ./fix-shell-path.patch
    ./0001-gitlab-runner-don-t-checked-for-fixed-runtime.patch
  ];

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = "https://about.gitlab.com/gitlab-ci/";
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ bachp zimbatm globin ];
  };
}
