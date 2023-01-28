{ lib
, stdenv
, fetchurl
, expat
, libpng
, udunits
, netcdf
, xorg
}:

let
  pname = "ncview";
  version = "2.1.8";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url    = "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz";
    sha256 = "1gliziyxil2fcz85hj6z0jq33avrxdcjs74d500lhxwvgd8drfp8";
  };

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
    homepage    = "http://meteora.ucsd.edu/~pierce/ncview_home_page.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jmettes ];
  };
}
