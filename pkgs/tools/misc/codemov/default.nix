{ lib
, rustPlatform
, fetchFromGitHub
, makeBinaryWrapper
, pkg-config
, oniguruma
, ffmpeg
, git
}:

rustPlatform.buildRustPackage {
  pname = "codemov";
<<<<<<< HEAD
  version = "unstable-2023-08-08";
=======
  version = "unstable-2022-10-24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codemov";
<<<<<<< HEAD
    rev = "8a4d6e50c21010866ca06f845f30c2aa54c09854";
    hash = "sha256-nOqh8kXS5mx0AM4NvIcwvC0lAZRHsQwrxI0c+9PeroU=";
  };

  cargoHash = "sha256-cyzoMD97ofrbm3BDAtl8pSezcM4B2TVbW9V5J6xRVLc=";
=======
    rev = "d51e83246eafef32c3a3f54407fe49eb9801f5ea";
    hash = "sha256-4Z3XASFlALCnX1guDqhBfvGNZ0V1XSruJvvSm0xr/t4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    wrapProgram $out/bin/codemov \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg git ]}
  '';

  meta = with lib; {
    description = "Create a video of how a git repository's code changes over time";
    homepage = "https://github.com/sloganking/codemov";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
