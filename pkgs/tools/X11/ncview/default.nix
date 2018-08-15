{ stdenv, fetchurl
, netcdf, x11, xorg, udunits, expat
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

  buildInputs = [ netcdf x11 xorg.libXaw udunits expat ];

  meta = with stdenv.lib; {
    description = "Visual browser for netCDF format files";
    homepage    = "http://meteora.ucsd.edu/~pierce/ncview_home_page.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jmettes ];
  };
}
