{ stdenv
, lib
, fetchFromGitea
, curl
, openssl
, nix-update-script
, testers
, snac2
}:

stdenv.mkDerivation rec {
  pname = "snac2";
<<<<<<< HEAD
  version = "2.35";
=======
  version = "2.30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "grunfink";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-V9Q9rjinFDFCi2snQ27R0Y9KFrYD/HLElnT8KV/3bP4=";
=======
    hash = "sha256-iHVoecIvRKE1nzzq8WdI4wuNBRfad0usOVHpyz6iekU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ curl openssl ];

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-Dst_mtim=st_mtimespec"
    "-Dst_ctim=st_ctimespec"
  ]);

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = {
    tests.version = testers.testVersion {
      package = snac2;
      command = "${meta.mainProgram} || true";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://codeberg.org/grunfink/snac2";
    description = "A simple, minimalistic ActivityPub instance (2.x, C)";
    changelog = "https://codeberg.org/grunfink/snac2/src/tag/${version}/RELEASE_NOTES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ misuzu ];
<<<<<<< HEAD
    platforms = platforms.unix;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "snac";
  };
}
