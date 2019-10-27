{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxslt, docbook_xsl
, gtk3, udev, systemd
}:

stdenv.mkDerivation rec {
  pname = "plymouth";
  version = "0.9.4";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/plymouth/releases/${pname}-${version}.tar.xz";
    sha256 = "0l8kg7b2vfxgz9gnrn0v2w4jvysj2cirp0nxads5sy05397pl6aa";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig libxslt docbook_xsl
  ];

  buildInputs = [
    gtk3 udev systemd
  ];

  postPatch = ''
    sed -i \
      -e "s#\$(\$PKG_CONFIG --variable=systemdsystemunitdir systemd)#$out/etc/systemd/system#g" \
      -e "s#plymouthplugindir=.*#plymouthplugindir=/etc/plymouth/plugins/#" \
      -e "s#plymouththemedir=.*#plymouththemedir=/etc/plymouth/themes#" \
      -e "s#plymouthpolicydir=.*#plymouthpolicydir=/etc/plymouth/#" \
      configure.ac

    configureFlags="
      --prefix=$out
      --bindir=$out/bin
      --sbindir=$out/sbin
      --exec-prefix=$out
      --libdir=$out/lib
      --libexecdir=$out/lib
      --sysconfdir=/etc
      --with-systemdunitdir=$out/etc/systemd/system
      --localstatedir=/var
      --with-logo=/etc/plymouth/logo.png
      --with-background-color=0x000000
      --with-background-start-color-stop=0x000000
      --with-background-end-color-stop=0x000000
      --with-release-file=/etc/os-release
      --without-system-root-install
      --without-rhgb-compat-link
      --enable-tracing
      --enable-systemd-integration
      --enable-pango
      --enable-gdm-transition
      --enable-gtk"

    installFlags="
      plymouthd_defaultsdir=$out/share/plymouth
      plymouthd_confdir=$out/etc/plymouth"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/Plymouth;
    description = "A graphical boot animation";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
