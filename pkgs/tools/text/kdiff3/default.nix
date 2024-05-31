{ stdenv
, lib
, fetchurl
, extra-cmake-modules
, kdoctools
, wrapQtAppsHook
, boost
, kcrash
, kconfig
, kinit
, kparts
, kiconthemes
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdiff3";
  version = "1.11.1";

  src = fetchurl {
    url = "mirror://kde/stable/kdiff3/kdiff3-${finalAttrs.version}.tar.xz";
    hash = "sha256-MPFKWrbg1VEWgpF42CdlTDDoQhwE/pcA085npTCEYpg=";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapQtAppsHook ];

  buildInputs = [ boost kconfig kcrash kinit kparts kiconthemes ];

  cmakeFlags = [ "-Wno-dev" ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -s "$out/Applications/KDE/kdiff3.app/Contents/MacOS" "$out/bin"
  '';

  meta = with lib; {
    description = "Compares and merges 2 or 3 files or directories";
    mainProgram = "kdiff3";
    homepage = "https://invent.kde.org/sdk/kdiff3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux ++ darwin;
  };
})
