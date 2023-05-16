{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "codevis";
<<<<<<< HEAD
  version = "0.8.4";
=======
  version = "0.8.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codevis";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-LZ6NsoyEPUvgcVdbG7U2Vzuz/TLLraScvW97PocUNpU=";
  };

  cargoHash = "sha256-sQKZJVnRs4IcBKmmaQDoJYBQtnuZW4aEICr6Xa8Flnk=";
=======
    hash = "sha256-J2cF0ELH9E05ZXRIZQU5qhU1taIorORtqIzq61hTHxQ=";
  };

  cargoHash = "sha256-9QRd/UWlaRTtTOjtBa2TzrxCNf/sBbKT3GUnr1Spw+g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

<<<<<<< HEAD
  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };
=======
  RUSTONIG_SYSTEM_LIBONIG = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A tool to take all source code in a folder and render them to one image";
    homepage = "https://github.com/sloganking/codevis";
<<<<<<< HEAD
    changelog = "https://github.com/sloganking/codevis/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
