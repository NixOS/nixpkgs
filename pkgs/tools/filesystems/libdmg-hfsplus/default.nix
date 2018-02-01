{ stdenv, fetchFromGitHub, cmake, zlib, bzip2, libpng, openssl }:

stdenv.mkDerivation rec {
  name = "libdmg-hfsplus-${version}";
  version = "2016-01-31";

  src = fetchFromGitHub {
    owner = "andreas56";
    repo = "libdmg-hfsplus";
    rev = "81dd75fd1549b24bf8af9736ac25518b367e6b63";
    sha256 = "0109zmz7nkydkrka98wmj0bjkskmxghw0k39a60ampywmsdi1vkh";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib bzip2 libpng openssl ];

  meta = with stdenv.lib; src.meta // {
    description = "Portable libraries and utilities that manipulate HFS+ volumes and Apple's DMG images";
    license     = licenses.gpl3Plus;
    platforms   = with platforms; linux ++ darwin;
  };
}

