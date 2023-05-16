{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pathvector";
<<<<<<< HEAD
  version = "6.3.2";
=======
  version = "6.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "natesales";
    repo = "pathvector";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-TqGasguEAcA5ET2E/uFjgIl7IHI2v9m5EaXpIMG3T8c=";
  };

  vendorHash = "sha256-hgUuntT6jMWI14qDE3Yjm5W8UqQ6CcvoILmSDaVEZac=";
=======
    sha256 = "sha256-5A5THSBVOAX+VsBbht7HobiHFEdv6dohUwCeegAijYE=";
  };

  vendorHash = "sha256-2G+RqG2i6APvpbOltQeP/Kt7d/LAwbecaYHOFrdnCQo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" "-X main.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "Declarative edge routing platform that automates route optimization and control plane configuration";
    homepage = "https://pathvector.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthewpi ];
  };
}
