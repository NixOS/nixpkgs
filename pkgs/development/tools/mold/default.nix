{ lib
, stdenv
, fetchFromGitHub
, cmake
, mimalloc
, ninja
, openssl
, zlib
, testers
, mold
<<<<<<< HEAD
, nix-update-script
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "mold";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "1.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rui314";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-4W6quVSkxS2I6KEy3fVyBTypD0fg4EecgeEVM0Yw58s=";
=======
    hash = "sha256-dfdrXp05eJALTQnx2F3GxRWKMA+Icj0mRPcb72z7qMw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals (!stdenv.isDarwin) [
    mimalloc
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    sed -i CMakeLists.txt -e '/.*set(DEST\ .*/d'
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cmakeFlags = [
    "-DMOLD_USE_SYSTEM_MIMALLOC:BOOL=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-faligned-allocation"
  ]);

<<<<<<< HEAD
  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = mold; };
  };
=======
  passthru.tests.version = testers.testVersion { package = mold; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A faster drop-in replacement for existing Unix linkers";
    longDescription = ''
      mold is a faster drop-in replacement for existing Unix linkers. It is
      several times faster than the LLVM lld linker. mold is designed to
      increase developer productivity by reducing build time, especially in
      rapid debug-edit-rebuild cycles.
    '';
    homepage = "https://github.com/rui314/mold";
    changelog = "https://github.com/rui314/mold/releases/tag/v${version}";
<<<<<<< HEAD
    license = licenses.mit;
    maintainers = with maintainers; [ azahi nitsky paveloom ];
=======
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ azahi nitsky ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
