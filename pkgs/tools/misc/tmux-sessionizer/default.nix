{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tmux-sessionizer";
<<<<<<< HEAD
  version = "0.2.3";
=======
  version = "0.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jrmoulton";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-TTt4pEWlt1cL9SBM6C5dX88MqhBqr4Qt8INnWny8WL4=";
  };

  cargoHash = "sha256-Jq4wpSKo5kq6xSr/qRPlMy9QREUHQ33oQgXrvKi25lM=";
=======
    sha256 = "sha256-fV+LBs+jbcOjArUfygEXkyxg/xGhI35YduUkx4AyQhk=";
  };

  cargoHash = "sha256-Bg4C4r3h/kaMsAqzit9JVuAe7vYrRB9W5OLOWPgCJHc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "The fastest way to manage projects as tmux sessions";
    homepage = "https://github.com/jrmoulton/tmux-sessionizer";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
  };
}
