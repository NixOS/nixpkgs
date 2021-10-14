{ lib
, buildGOGPackage
, fetchGOG
, gtk2-x11
, zlib
, nss
, xorg
, dbus_libs
, cairo
, nspr
, alsaLib
, gdk_pixbuf
, gnome2
, glib
, expat
, libuuid
, atk
, vivaldi-widevine
, stdenv
}:

buildGOGPackage rec {
  displayName = "Stellaris";
  pname = "stellaris";
  version = "3.1.2.50367";

  src = fetchGOG {
    slug = "stellaris";
    filename = "${pname}_${builtins.replaceStrings ["."] ["_"] version}.sh";
    sha256 = "sha256-86rXYSAjoggvw1cem3GHbYlvKWy7MasXg20KelU3I9Q=";
  };

  buildInputs = [
    gtk2-x11
    zlib
    nss
    dbus_libs
    cairo
    nspr
    alsaLib
    gdk_pixbuf
    stdenv.cc.cc.lib
    glib
    expat
    (vivaldi-widevine.overrideAttrs (super: {
      installPhase = ''
        ${super.installPhase}
        install -vD libwidevinecdm.so $out/lib/libwidevinecdm.so
      '';
    }))
    libuuid
    atk
  ] ++ (with gnome2; [ gtk pango ]) ++ (with xorg; [
    libxcb
    libXdamage
    libX11
    libXrandr
    libXi
    libXcomposite
    libXrender
    libXext
    libXcursor
    libXScrnSaver
    libXfixes
    libICE
    libXtst
    libSM
  ]);

  meta = with lib; {
    description = "A science fiction 4x grand strategy game, purchased from GOG.com";
    homepage = "https://www.paradoxplaza.com/stellaris";
    license = licenses.unfree;
    maintainers = with maintainers; [ pmc ];
    platforms = [ "x86_64-linux" ];
  };
}
