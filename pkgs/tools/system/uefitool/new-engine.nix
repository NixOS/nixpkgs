{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  cmake,
  wrapQtAppsHook,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uefitool";
  version = "A73";

  src = fetchFromGitHub {
    hash = "sha256-XZGddj0i/r1rqntEcqU2AK6ihvqwN031TR12qmEmKLk=";
    owner = "LongSoft";
    repo = "uefitool";
    tag = finalAttrs.version;
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [
    cmake
    zip
    wrapQtAppsHook
  ];
  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./bundle-destination.patch ];

  meta = {
    description = "UEFI firmware image viewer and editor";
    homepage = "https://github.com/LongSoft/uefitool";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ athre0z ];
    platforms = lib.platforms.unix;
    mainProgram = "uefitool";
  };
})
