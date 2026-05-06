{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  wrapGAppsHook3,
  cmake,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uefitool";
  version = "A74";

  src = fetchFromGitHub {
    owner = "LongSoft";
    repo = "uefitool";
    tag = finalAttrs.version;
    hash = "sha256-pgtlVv5hXzQzOJInHB96jb1OK7QU3TMWmw1h8H4lNuU=";
  };

  buildInputs = [ qt6.qtbase ];

  nativeBuildInputs = [
    cmake
    zip
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./bundle-destination.patch ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "UEFI firmware image viewer and editor";
    homepage = "https://github.com/LongSoft/uefitool";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ athre0z ];
    platforms = lib.platforms.unix;
    mainProgram = "uefitool";
  };
})
