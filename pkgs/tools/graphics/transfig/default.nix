{ stdenv, fetchurl, zlib, libjpeg, libpng, xorg, Xaw3d }:

stdenv.mkDerivation rec {
  name = "transfig-3.2.6a";
  src = fetchurl {
    url = https://sourceforge.net/projects/mcj/files/xfig-3.2.6a.tar.xz;
    sha256 = "0z1636w27hvgjpq98z40k8h535b4x2xr2whkvr7bibaa89fynym8";
  };

  buildInputs = with xorg;
    [ zlib libjpeg libpng Xaw3d
      libX11 libXau libXaw libXext libXft libXmu libXpm libXt
];

  hardeningDisable = [ "format" ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
