{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wireproxy";
<<<<<<< HEAD
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "pufferffish";
    repo = "wireproxy";
    rev = "v${version}";
    hash = "sha256-Sy8jApnU3dpsXi5vWyEY6D250xpG73aByNZ/pSg90l0=";
=======
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "octeep";
    repo = "wireproxy";
    rev = "v${version}";
    hash = "sha256-5xyKmFxXYhrR8EbG1/ByD10lhkPT9Ky1lq+LL2djaao=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-LBLEb2oVi5ILNtoOtmJZ7NC7hMvLZcexYAxwmb4iUBo=";
=======
  vendorHash = "sha256-/LZs6N2m5nHx735Ug+PcM1I1ZL9f8VYEpd7Tt4WizMQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Wireguard client that exposes itself as a socks5 proxy";
    homepage = "https://github.com/octeep/wireproxy";
    license = licenses.isc;
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
