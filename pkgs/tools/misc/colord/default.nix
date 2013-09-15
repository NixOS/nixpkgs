{ stdenv, fetchurl, fetchgit
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
    name = "colord-git-11dca";
    src = fetchgit {
      url = "https://github.com/hughsie/colord.git";
      rev = "11dcaba034edff3955ceff53795df82c57c34adc";
      sha256 = "1280q7zbfm5wqql872kcxmk5rmwjs7cv7cgz8nx0i9g4ac8j2mrf";
    };

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
