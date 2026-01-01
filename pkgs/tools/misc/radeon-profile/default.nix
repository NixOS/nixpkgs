{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qtbase,
  qtcharts,
  qmake,
  libXrandr,
  libdrm,
}:

mkDerivation rec {

  pname = "radeon-profile";
  version = "20200824";

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    qtbase
    qtcharts
    libXrandr
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

<<<<<<< HEAD
  meta = {
    description = "Application to read current clocks of AMD Radeon cards";
    homepage = "https://github.com/marazmista/radeon-profile";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Application to read current clocks of AMD Radeon cards";
    homepage = "https://github.com/marazmista/radeon-profile";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "radeon-profile";
  };

}
