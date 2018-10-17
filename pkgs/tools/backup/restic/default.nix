{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "restic-${version}";
  version = "0.9.3";

  goPackagePath = "github.com/restic/restic";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    sha256 = "0l35pdrq1hhcz3cb2qm267m6846mxfwbl1adk2kp748b2q55pdma";
  };


  buildPhase = ''
    cd go/src/${goPackagePath}
    GO111MODULE=on GOCACHE=`mktemp -d` go run -mod=vendor build.go
  '';

  installPhase = ''
    mkdir -p \
      $bin/bin \
      $bin/etc/bash_completion.d \
      $bin/share/zsh/vendor-completions \
      $bin/share/man/man1
    cp restic $bin/bin/
    $bin/bin/restic generate \
      --bash-completion $bin/etc/bash_completion.d/restic.sh \
      --zsh-completion $bin/share/zsh/vendor-completions/_restic \
      --man $bin/share/man/man1
  '';

  meta = with lib; {
    homepage = https://restic.net;
    description = "A backup program that is fast, efficient and secure";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = [ maintainers.mbrgm ];
  };
}
