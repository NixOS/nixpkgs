{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxslt, docbook_xsl
, gtk3, udev, systemd
}:

stdenv.mkDerivation rec {
  name = "plymouth-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/plymouth/releases/${name}.tar.bz2";
    sha256 = "0zympsgy5bbfl2ag5nc1jxlshpx8r1s1yyjisanpx76g88hfh31g";
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
