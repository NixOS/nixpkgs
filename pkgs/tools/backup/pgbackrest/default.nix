{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, postgresql
, openssl
, lz4
, bzip2
, libxml2
, zlib
, zstd
, libyaml
}:
stdenv.mkDerivation rec {
  pname = "pgbackrest";
<<<<<<< HEAD
  version = "2.47";
=======
  version = "2.45";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pgbackrest";
    repo = "pgbackrest";
    rev = "release/${version}";
<<<<<<< HEAD
    sha256 = "sha256-HKmJA/WlMR6Epu5WuD8pABDh5gaN+T98lc4ejgoD8LM=";
=======
    sha256 = "sha256-wm7wNxxwRAmFG7ZsZMR8TXp+xVu673g6w95afLalnc8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ postgresql openssl lz4 bzip2 libxml2 zlib zstd libyaml ];

  postUnpack = ''
    sourceRoot+=/src
  '';

  meta = with lib; {
    description = "Reliable PostgreSQL backup & restore";
    homepage = "https://pgbackrest.org/";
    changelog = "https://github.com/pgbackrest/pgbackrest/releases";
    license = licenses.mit;
<<<<<<< HEAD
    mainProgram = "pgbackrest";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ zaninime ];
  };
}
