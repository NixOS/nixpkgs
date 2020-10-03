{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "13.4.0";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-x86_64.tar.xz";
    sha256 = "0rdnrnkm9pcdzi3ddmk0ia9r6lv548by08q1nrb7683jywr7bin3";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-arm.tar.xz";
    sha256 = "1nd32vqp096h36p89c0v21yijn3dzz4ix5bwsbl20mc8m802wvg7";
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
    sha256 = "124gplxs3a6kyc7b7mwsf0l02i9qi0ifjn3r2m7vq5wvk31qa97b";
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
