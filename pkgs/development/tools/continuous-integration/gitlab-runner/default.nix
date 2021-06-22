{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "14.0.0";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/binaries/gitlab-runner-helper/gitlab-runner-helper.x86_64";
    sha256 = "156dm6kg154fyn3axgw7kcpq9xz8mxdyhch8snp0vxzh941sc74w";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/binaries/gitlab-runner-helper/gitlab-runner-helper.arm";
    sha256 = "0cnjbcc3bdiahff3iyxwppj9gwaj7r7x80hk2cv2q4hkdpsji655";
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
    sha256 = "14g78m5h5d02k04lc07jc8yp7sqmfkjif589rb8wkb9jmbh7glmi";
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
