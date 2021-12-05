{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let version = "14.5.0";
in buildGoPackage rec {
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
    sha256 = "sha256-BxnIrjiEW61J6hl7mWNXc2Vb4ae1cWqOypTy9Xo7Hkc=";
  };

  patches = [ ./fix-shell-path.patch ];

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = "https://about.gitlab.com/gitlab-ci/";
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ bachp zimbatm globin ];
  };
}
