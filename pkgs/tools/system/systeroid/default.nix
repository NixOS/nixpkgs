{ lib
, rustPlatform
, fetchFromGitHub
, linux-doc
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "systeroid";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-yEsDtjoV0NQPG/PJnVMBBMuPDBdK2kIfUWxtfkvRI04=";
=======
    sha256 = "sha256-1qZ0vryWFGoIC3gdgJv6HolqCV8fogAZnjGHYnbP8Es=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace systeroid-core/src/parsers.rs \
      --replace '"/usr/share/doc/kernel-doc-*/Documentation/*",' '"${linux-doc}/share/doc/linux-doc/*",'
  '';

<<<<<<< HEAD
  cargoHash = "sha256-Plu7JxTFjLUXWLmIax/QPgq7QzdQd0vFinj+Gx03AQQ=";
=======
  cargoHash = "sha256-aWkWufHZaAmebdDdrgrIbQrSSzj/RgymQ4hOkGtY2Zc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    xorg.libxcb
  ];

  # tries to access /sys/
  doCheck = false;

  meta = with lib; {
    description = "More powerful alternative to sysctl(8) with a terminal user interface";
    homepage = "https://github.com/orhun/systeroid";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
