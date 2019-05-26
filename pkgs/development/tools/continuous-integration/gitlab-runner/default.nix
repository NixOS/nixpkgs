{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "11.10.1";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-x86_64.tar.xz";
    sha256 = "120gpyim54mc8z84gzpbms5hkg2xg4sgzdvkrn1fis9myvd55bav";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-arm.tar.xz";
    sha256 = "0qfqsi1fm94sxv7g975fw0av871f677rp48yv8q5669ipm16n9qk";
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
    sha256 = "1nxv783rdzdwm0qq3li893p7q3n8gg7abla2961f3n735gjlnibx";
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
