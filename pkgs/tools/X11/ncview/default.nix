{ lib
, stdenv
, fetchurl
, expat
, libpng
, udunits
, netcdf
, xorg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncview";
  version = "2.1.8";

  src = fetchurl {
    url = "ftp://cirrus.ucsd.edu/pub/ncview/ncview-${finalAttrs.version}.tar.gz";
    hash = "sha256-6LrcUHubd0gBKI0cLVnreasxsATfSFjQZ07Q2H38kb4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    netcdf
  ];

  buildInputs = [
    expat
    libpng
    netcdf
    udunits
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXaw
    xorg.libXt
  ];

  meta = with lib; {
    description = "Visual browser for netCDF format files";
    homepage = "http://meteora.ucsd.edu/~pierce/ncview_home_page.html";
    license = licenses.gpl3Plus;
    mainProgram = "ncview";
    maintainers = with maintainers; [ jmettes ];
    platforms = platforms.all;
  };
})
