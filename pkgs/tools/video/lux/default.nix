{ lib, buildGoModule, fetchFromGitHub, makeWrapper, ffmpeg }:

buildGoModule rec {
  pname = "lux";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "iawia002";
    repo = "lux";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-klm1985qBErFfYIWPjr1/n6nYr/jA9dbrDMfw4bf1tM=";
=======
    sha256 = "sha256-A3DDKpoaZlDUpafAGs5zCknhTeCuwMPnyBHtxke0Bi8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = "sha256-7wgGJYiIsVTRSuSb4a9LgYCkkayGhNMKqcIKoDxMuAM=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    wrapProgram $out/bin/lux \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  doCheck = false;

  meta = with lib; {
    description = "Fast and simple video download library and CLI tool written in Go";
    homepage = "https://github.com/iawia002/lux";
    changelog = "https://github.com/iawia002/lux/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [];
  };
}
