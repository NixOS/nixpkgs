{ stdenv, fetchurl, autoconf, automake, cairo, docbook_xsl, gtk
, libdrm, libpng , libtool, libxslt, makeWrapper, pango, pkgconfig
, udev
}:

stdenv.mkDerivation rec {
  name = "plymouth-${version}";
  version = "0.9.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/plymouth/releases/${name}.tar.bz2";
    sha256 = "0kfdwv179brg390ma003pmdqfvqlbybqiyp9fxrxx0wa19sjxqnk";
  };

  buildInputs = [
    autoconf automake cairo docbook_xsl gtk libdrm libpng libtool
    libxslt makeWrapper pango pkgconfig udev
  ];

  prePatch = ''
    sed -e "s#\$(\$PKG_CONFIG --variable=systemdsystemunitdir systemd)#$out/etc/systemd/system#g" \
      -i configure.ac
  '';

  configurePhase = ''
    ./configure \
      --prefix=$out \
      -bindir=$out/bin \
      -sbindir=$out/sbin \
      --exec-prefix=$out \
      --libdir=$out/lib \
      --libexecdir=$out/lib \
      --sysconfdir=$out/etc \
      --localstatedir=/var \
      --with-log-viewer \
      --without-system-root-install \
      --without-rhgb-compat-link \
      --enable-tracing \
      --enable-systemd-integration \
      --enable-pango \
      --enable-gtk
  '';

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/Plymouth;
    description = "A graphical boot animation";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
