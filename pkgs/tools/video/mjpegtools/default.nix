{ stdenv, lib, fetchurl, gtk, libdv, libjpeg, libpng, libX11, pkgconfig, SDL, SDL_gfx
, withMinimal ? false
}:

# TODO:
# - make dependencies optional
# - libpng-apng as alternative to libpng?
# - libXxf86dga support? checking for XF86DGAQueryExtension in -lXxf86dga... no

stdenv.mkDerivation rec {
  name = "mjpegtools-2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/mjpeg/${name}.tar.gz";
    sha256 = "01y4xpfdvd4zgv6fmcjny9mr1gbfd4y2i4adp657ydw6fqyi8kw6";
  };

  buildInputs = [ libdv libjpeg libpng pkgconfig ]
              ++ lib.optional (!withMinimal) [ gtk libX11 SDL SDL_gfx ];

  postPatch = ''
    sed -i -e '/ARCHFLAGS=/s:=.*:=:' configure
  '';

  enableParallelBuilding = true;

  outputs = [ "out" "lib" ];

  meta = with stdenv.lib; {
    description = "A suite of programs for processing MPEG or MJPEG video";
    homepage = http://mjpeg.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
