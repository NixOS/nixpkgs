{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  wrapQtAppsHook,
  qtbase,
  qtcharts,
  libxrandr,
  libdrm,
}:

stdenv.mkDerivation rec {

  pname = "radeon-profile";
  version = "20200824";

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtcharts
    libxrandr
    libdrm
  ];

  src =
    (fetchFromGitHub {
      owner = "marazmista";
      repo = "radeon-profile";
      rev = version;
      sha256 = "0z6a9w79s5wiy8cvwcdp5wmgf6702d0wzw95f6176yhp4cwy4cq2";
    })
    + "/radeon-profile";

  preConfigure = ''
    substituteInPlace radeon-profile.pro \
      --replace "/usr/" "$out/"
  '';

  meta = {
    description = "Application to read current clocks of AMD Radeon cards";
    homepage = "https://github.com/marazmista/radeon-profile";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "radeon-profile";
  };

}
