{stdenv, fetchurl
, glib, polkit, pkgconfig, intltool, gusb, libusb1, lcms2, sqlite, systemd, dbus

, automake, autoconf, libtool, gtk_doc, which, gobjectIntrospection
, version ? "git"
}:

# colord wants to write to the etc/colord.conf and var/run/colord/mapping.db
# thus they get symlinked to /etc and /var

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "colord" version {
  "0.1.33" = {
    name = "colord-0.1.33";
    src = fetchurl {
      url = http://www.freedesktop.org/software/colord/releases/colord-0.1.32.tar.xz;
      sha256 = "1smbkh4z1c2jjwxg626f12sslv7ff3yzak1zqrc493cl467ll0y7";
    };
  };
  "git" = {
    # REGION AUTO UPDATE: { name="colord"; type="git"; url="git://github.com/hughsie/colord.git"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/colord-git-11dca.tar.bz2"; sha256 = "218152dcfb326e0739dc5cd2d815f0238df64b526bdfca006b6a4c3e563c385a"; });
    name = "colord-git-11dca";
    # END

    preConfigure = ''
      ./autogen.sh
    '';
    buildInputs = [ automake autoconf libtool gtk_doc which gobjectIntrospection ];
  };
} {

  enableParallelBuilding = true;

  preConfigure = ''
    configureFlags="$configureFlags --with-udevrulesdir=$out/lib/udev/rules.d --with-systemdsystemunitdir=$out/lib/udev/rules.d"
  '';

  buildInputs = [glib polkit pkgconfig intltool gusb libusb1 lcms2 sqlite systemd dbus];

  postInstall = ''
    sed -i '/usb_id\|usb-db/d' $out/lib/udev/rules.d/69-cd-sensors.rules
    mv $out/etc/colord.conf{,.default}
    ln -s /etc/colord.conf $out/etc/colord.conf
    rm -fr $out/var/lib/colord
    ln -s /var/lib/colord $out/var/lib/colord
  '';

  meta = {
    description = "system service that makes it easy to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = http://www.freedesktop.org/software/colord/intro.html;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
})
