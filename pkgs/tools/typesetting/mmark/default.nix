{ lib, buildGoModule, fetchFromGitHub, testers, mmark }:

buildGoModule rec {
  pname = "mmark";
<<<<<<< HEAD
  version = "2.2.32";
=======
  version = "2.2.31";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mmarkdown";
    repo = "mmark";
<<<<<<< HEAD
    # The tag has an outdated version number and fails the versio ntest
    # The pinned revision includes one extra commit that fixes the issue
    # rev = "v${version}";
    rev = "158e9cca0280c58e205cb69b02bf33d7d826915e";
    hash = "sha256-OzmqtmAAsG3ncrTl2o9rhK75i1WIpDnph0YrY38SlU0=";
=======
    rev = "v${version}";
    sha256 = "sha256-mCnlLsvkkB7ZvBCLYHvYanz9XgWo92v5M/kKulhUKTE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-GjR9cOGLB6URHQi+qcyNbP7rm0+y4wypvgUxgJzIgGQ=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = mmark;
  };

  meta = {
    description = "A powerful markdown processor in Go geared towards the IETF";
    homepage = "https://github.com/mmarkdown/mmark";
    license = with lib.licenses; bsd2;
    maintainers = with lib.maintainers; [ yrashk ];
<<<<<<< HEAD
=======
    platforms = lib.platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
