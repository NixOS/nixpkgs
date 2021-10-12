{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "14.3.2";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/binaries/gitlab-runner-helper/gitlab-runner-helper.x86_64";
    sha256 = "0np2ijgrq6yg3r0744qlj9a9va7y996f7csfs4ajyfqq3vm7jz2g";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/binaries/gitlab-runner-helper/gitlab-runner-helper.arm";
    sha256 = "0adjczad3y2f55i76pcp1q2kzdwqr04y59bslb9523s4dlav9jcd";
  };
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
    sha256 = "15mwyhr7a4b9vl7c0qz299qv91h3kcmf6d6p5vjjrm1phiy3bpgf";
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
