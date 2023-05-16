{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, installShellFiles
, gopass
}:

buildGoModule rec {
  pname = "gopass-jsonapi";
<<<<<<< HEAD
  version = "1.15.7";
=======
  version = "1.15.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-jsonapi";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lwY5uc6eKqXO8FbvzlrpQY0y5AEcV0RQFvvnE+At6z0=";
  };

  vendorHash = "sha256-BKwgP22l4t4jaAHHh+ZD/2nroCtAp/A6DqHt+9HZzKw=";
=======
    hash = "sha256-ZSX5g1agmnPU8Nlmptr3GVrjtPPKbDxouSjz9ulSW44=";
  };

  vendorHash = "sha256-JWOBGTJFzihoznYFzcgjayAzNof6Ob5u3Jfx2a6zwEk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-jsonapi \
      --prefix PATH : "${gopass.wrapperPath}"
  '';

  meta = with lib; {
    description = "Enables communication with gopass via JSON messages";
<<<<<<< HEAD
    homepage = "https://github.com/gopasspw/gopass-jsonapi";
    changelog = "https://github.com/gopasspw/gopass-jsonapi/blob/v${version}/CHANGELOG.md";
=======
    homepage = "https://www.gopass.pw/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ maxhbr ];
  };
}
