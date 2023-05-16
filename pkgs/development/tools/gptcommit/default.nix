{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, nix-update-script
, Security
, openssl
}:

let
  pname = "gptcommit";
<<<<<<< HEAD
  version = "0.5.13";
=======
  version = "0.5.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zurawiki";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-O0dqLN2wDXRIVcb9whlzK0BJOm/qhTH+nLpCwSUObng=";
  };

  cargoSha256 = "sha256-JwwQaThefWhJVRJ/a0WfdKJqr/NHgll6D6Y2QaeqWsc=";
=======
    sha256 = "sha256-K4A0np8+gpFpSU4jBv6PAw4RyUWmIB7dTgWvpy36CYY=";
  };

  cargoSha256 = "sha256-awztElsrJCUGUn2HcGpCkxUO/nEy8iZO22/fQtwAKdg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  # 0.5.6 release has failing tests
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [ Security ] ++ lib.optionals stdenv.isLinux [ openssl ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A git prepare-commit-msg hook for authoring commit messages with GPT-3. ";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}

