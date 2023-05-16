{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mmctl";
<<<<<<< HEAD
  version = "7.10.5";
=======
  version = "7.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mmctl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-FQdxFvYJ+YrOc1p3/Ju3ZOGFH32WeZjHXtsIYG+O0U0=";
=======
    sha256 = "sha256-ptkpPwTSoWZhcPAFfBhB73F/eubzzeGPI99K/K3ZT64=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  checkPhase = "make test";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mmctl/v6/commands.Version=${version}"
  ];

  meta = with lib; {
    description = "A remote CLI tool for Mattermost";
    homepage = "https://github.com/mattermost/mmctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ ppom ];
  };
}
