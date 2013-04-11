{ stdenv, fetchurl, cairo, gtk, libdrm, libpng, pango, pkgconfig }:

stdenv.mkDerivation rec {
  name = "plymouth-${version}";
  version = "0.8.8";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/plymouth/releases/${name}.tar.bz2";
    sha256 = "16vm3llgci7h63jaclfskj1ii61d8psq7ny2mncml6m3sghs9b8v";
  };

  buildInputs = [
    cairo gtk libdrm libpng pango pkgconfig
  ];


  configurePhase = ''
    export DESTDIR=$out
    ./configure -sbindir=$out/sbin \
      --prefix=$out \
      --exec-prefix=$out \
      --libdir=$out/lib \
      --libexecdir=$out/lib \
      --with-system-root-install \
      --enable-tracing \
      --with-rhgb-compat-link \
      --sysconfdir=/etc \
      --localstatedir=/var
  '';

  postInstall = ''
    cd $out/$out
    mv bin/* $out/bin
    mv sbin/* $out/sbin
    rmdir bin
    rmdir sbin
    mv * $out/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/Plymouth;
    description = "A graphical boot animation";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
  };
}
