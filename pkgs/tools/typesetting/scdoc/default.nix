{ lib
, stdenv
, fetchFromSourcehut
, buildPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scdoc";
  version = "1.11.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scdoc";
    rev = finalAttrs.version;
    hash = "sha256-2NVC+1in1Yt6/XGcHXP+V4AAz8xW/hSq9ctF/Frdgh0=";
  };

  outputs = [ "out" "man" "dev" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-static" ""
    substituteInPlace include/str.h \
      --replace "struct str *str_create();" "struct str *str_create(void);"
    substituteInPlace src/string.c \
      --replace "struct str *str_create() {" "struct str *str_create(void) {"
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "HOST_SCDOC=${lib.getExe buildPackages.scdoc}"
  ];

  doCheck = true;

  meta = {
    description = "A simple man page generator written in C99 for POSIX systems";
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ primeos AndersonTorres ];
    platforms = lib.platforms.unix;
    mainProgram = "scdoc";
  };
})
