{ 
  stdenv
, fetchurl
, pciutils
, confuse
, dbus, dbus_glib
, alsaLib
, audiofile
, eject
, pkgconfig
, gtk
, gettext
, libXpm
}:

let

  build_flags_patch = fetchurl {
    url = http://patch-tracker.debian.org/patch/series/dl/pommed/1.39~dfsg-2/build_flags.patch;
    sha256 = "109n5v0m91fqf8vqnpqg1zw8mk8fi9pkzqsfrmlavalg4xz49x9j";
  }; 

in

stdenv.mkDerivation rec {
  name = "pommed-1.39";

  src = fetchurl {
    url = "http://alioth.debian.org/frs/download.php/3583/${name}.tar.gz";
    sha256 = "18lxywmikanjr5pk1jdqda88dxd2579fpyd332xn4njjhlgwy5fp";
  };

  patches = [ build_flags_patch ];

  buildInputs = [
    pciutils
    confuse
    dbus
    alsaLib
    audiofile
    eject
    dbus_glib
    pkgconfig
    gtk
    gettext
    libXpm
  ];

  installPhase = ''
    mkdir -pv $out/bin $out/etc/init.d $out/etc/dbus-1/system.d \
      $out/share/pommed $out/share/gpomme $out/share/applications \
      $out/share/icons/hicolor/scalable/apps $out/share/pixmaps

    install -v -m755 pommed/pommed wmpomme/wmpomme gpomme/gpomme $out/bin
    install -v -m644 pommed/data/* $out/share/pommed
    install -v -m644 pommed.conf.mactel $out/etc/pommed.conf
    install -v -m644 pommed.init $out/etc/init.d
    install -v -m644 dbus-policy.conf $out/etc/dbus-1/system.d/pommed.conf

    cp -av gpomme/themes $out/share/gpomme
    for lang in de es fr it ja; do
      mkdir -pv $out/share/locale/"$lang"/LC_MESSAGES
      install -v -m644 gpomme/po/"$lang".mo $out/share/locale/"$lang"/LC_MESSAGES/gpomme.mo
    done
    install -v -m644 gpomme/gpomme*.desktop $out/share/applications
    for size in 128 16 192 22 24 32 36 48 64 72 96; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      install -v -m644 icons/gpomme_"$size"x"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps
    done
    install -v -m644 icons/gpomme.svg  $out/share/icons/hicolor/scalable/apps

    install -v -m644 icons/gpomme_192x192.xpm $out/share/pixmaps/wmpomme.xpm
  '';

  meta = {
    description = "A tool to handle hotkeys on Apple laptop keyboards";
    homepage = http://www.technologeek.org/projects/pommed/index.html;
    license = "gplv2";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
