{ lib, nix-update-script, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goda";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "goda";
    rev = "v${version}";
    sha256 = "sha256-kilFb/2wXdzn/gXy9mBg0PZH8rd+MFIom4AGAZLgnBo=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-FYjlOYB0L4l6gF8hYtJroV1qMQD0ZmKWXBarjyConRs=";
=======
  vendorSha256 = "sha256-FYjlOYB0L4l6gF8hYtJroV1qMQD0ZmKWXBarjyConRs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/loov/goda";
    description = "Go Dependency Analysis toolkit";
    maintainers = with maintainers; [ michaeladler ];
    license = licenses.mit;
    mainProgram = "goda";
  };
}
