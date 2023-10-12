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
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "mold";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "rui314";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4W6quVSkxS2I6KEy3fVyBTypD0fg4EecgeEVM0Yw58s=";
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

  cmakeFlags = [
    "-DMOLD_USE_SYSTEM_MIMALLOC:BOOL=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-faligned-allocation"
  ]);

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = mold; };
  };

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
    license = licenses.mit;
    maintainers = with maintainers; [ azahi nitsky paveloom ];
    mainProgram = "mold";
    platforms = platforms.unix;
  };
}
