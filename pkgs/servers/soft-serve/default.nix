{ lib, buildGoModule, fetchFromGitHub, makeWrapper, git }:

buildGoModule rec {
  pname = "soft-serve";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-LrqkLZ7ouMUrE3vHYC0ZwmblaYL6b5fY2RYEYOOxNYQ=";
  };

  vendorHash = "sha256-RQQvR4d5dtzboPYJwdeUqfGwSun04gs7hm1YYAt8OPo=";
=======
    sha256 = "sha256-Bjb2CC7yWhbVyKAL2+R+qLfkElux7pSgkD/glkv/jVw=";
  };

  vendorHash = "sha256-JVEUR05ciD5AX2uhQjWFNVSY2qD2M4kti9ACHyb+UfM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/soft \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description = "A tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    changelog = "https://github.com/charmbracelet/soft-serve/releases/tag/v${version}";
    mainProgram = "soft";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
