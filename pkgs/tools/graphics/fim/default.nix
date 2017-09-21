{ stdenv, fetchurl, autoconf, automake, pkgconfig, perl
, flex, bison, readline
, giflib, libtiff, libexif, libpng, libjpeg, jasper
, aalib, inkscape#, SDL, fig2dev, jasper # TODO
}:

stdenv.mkDerivation rec {
  name = "fim-${version}";
  version = "0.5rc3";

  src = fetchurl {
    url = mirror://savannah/fbi-improved/fim-0.5-rc3.tar.gz;
    sha256 = "12aka85h469zfj0zcx3xdpan70gq8nf5rackgb1ldcl9mqjn50c2";
  };

  postPatch = ''
   substituteInPlace doc/vim2html.pl \
     --replace /usr/bin/perl ${perl}/bin/perl
  '';

  nativeBuildInputs = [ autoconf automake pkgconfig ];

  buildInputs = [
    perl flex bison readline
    giflib libtiff libexif libpng libjpeg jasper aalib inkscape
  ];

  meta = with stdenv.lib; {
    description = "A lightweight, highly customizable and scriptable image viewer";
    longDescription = ''
      FIM (Fbi IMproved) is a lightweight, console based image viewer that aims
      to be a highly customizable and scriptable for users who are comfortable
      with software like the VIM text editor or the Mutt mail user agent.
    '';
    homepage = http://www.nongnu.org/fbi-improved/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
