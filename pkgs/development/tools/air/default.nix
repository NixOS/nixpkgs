{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
<<<<<<< HEAD
  version = "1.45.0";
=======
  version = "1.43.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-q1BnY0ztnhtsks1+GC1awR9o6nodXyb8rf1waVAs3gM=";
  };

  vendorHash = "sha256-vyuXmQEjy5kPk9cKosHx0JZSZxstYtCNyfLIlRt2bnk=";
=======
    hash = "sha256-gFMT/casY2ASbh0UzUjtgVGCiVFcFHBlvWlRptqRw3Y=";
  };

  vendorHash = "sha256-n2Ei+jckSYAydAdJnMaPc7FGUcwSbC49hk6nlDyDMPE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

   ldflags = [ "-s" "-w" "-X=main.airVersion=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
