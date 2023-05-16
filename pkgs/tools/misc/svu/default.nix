{ lib, buildGoModule, fetchFromGitHub, testers, svu }:

buildGoModule rec {
  pname = "svu";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-FmSBh2XxwxmIbX2TILnk+YUYbMQQbOb89uvnpl4b+7Y=";
=======
    sha256 = "37AT+ygN7u3KfFqr26M9c7aTt15z8m4PBrSd+G5mJcE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-+e1oL08KvBSNaRepGR2SBBrEDJaGxl5V9rOBysGEfQs=";

  ldflags = [ "-s" "-w" "-X=main.version=${version}" "-X=main.builtBy=nixpkgs" ];

  # test assumes source directory to be a git repository
  postPatch = ''
    rm internal/git/git_test.go
  '';

  passthru.tests.version = testers.testVersion { package = svu; };

  meta = with lib; {
    description = "Semantic Version Util";
    homepage = "https://github.com/caarlos0/svu";
    maintainers = with maintainers; [ caarlos0 ];
    license = licenses.mit;
  };
}
