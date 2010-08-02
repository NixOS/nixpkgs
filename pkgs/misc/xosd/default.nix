{ stdenv, fetchurl, libX11, libXext, libXt, xextproto, xproto }:

stdenv.mkDerivation rec {
  pname = "xosd";
  version = "2.2.12";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ignavus.net/${name}.tar.gz";
    sha256 = "7d4ae8e1a6dbd7743af3b1cdc85144e2de26abe6daec25f4bd74bf311774df08";
  };

  buildInputs = [ libX11 libXext libXt xextproto xproto ];

  meta = {
    description = "XOSD displays text on your screen";
  };
}
