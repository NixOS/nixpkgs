/*

Systeemvereisten

* libz >= 1.1.4
* glib >= 2.2.0
* gtk >= 2.2.0

Glib 2 is een 'dependency' van gtk2. Als je gtk2 op je systeem hebt staan dan heb je ongetwijfeld ook glib2 op je systeem. Zie: www.gtk.org voor meer informatie omtrent Glib/gtk2
Alhoewel FTD4Linux gtk 2.2 als minimumvereiste heeft raden we toch aan om gtk 2.4 te gebruiken. Dit vanwege een bug in gtk versies 2.2.2 t/m 2.2.4.

* libxml2 >= 2.2.5
* libxslt >= 1.0.5

* mozilla (gecompileerd met gtk2 support)
Mozilla is de opensource browser die is voortgekomen uit het vrijgeven van de netscape navigator source code. Als je mozilla reeds op je systeem hebt staan zou je even moeten nagaan of deze tegen gtk2 is gelinkt. Dit kun je doen met behulp van het programma ldd.
ldd /usr/X11R6/lib/mozilla-gtk2/libgtkembedmoz.so | grep gtk
/usr/X11R6/lib/mozilla-gtk2/libgtkembedmoz.so:
libgtk-x11-2.0.so.200 => /usr/X11R6/lib/libgtk-x11-2.0.so.200 (0x282c3000)
In de output van het ldd programma kun je zien of er inderdaad wordt gelink tegen gtk2. (libgtk-x11-2.0.so.200).
Heb je geen mozilla, maar heb je wel de firebird/firefox variant geinstalleerd staan dan kun je ook met de mozilla compatible onderdelen van firebird/firefox aan de gang. Je hebt hier echter wel de header (development) bestanden bij nodig. Controleer dus even of jouw firebird/firefox installatie hiermee is geleverd. (gtkembedmoz/gtkmozembed.h) Een 'locate gtkmozembed.h' zou hier snel genoeg uitsluitsel over moeten geven.

* OpenSSL
* LibCURL

*/

{ stdenv, fetchurl
, zlib, libxml2, libxslt, firefox, openssl, curl
, glib, gtk, libgnomeui, libgtkhtml
, pkgconfig, dbus-glib, realCurl, pcre, libsexy, gtkspell, libnotify
}:
 
stdenv.mkDerivation {
  name = "openftd-0.98.6";
  #builder = ./builder.sh;

  src = fetchurl {
    url = http://speeldoos.eweka.nl/~paul/openftd/openftd-1.0.1.tar.bz2;
    sha256 = "e0710865f852fdf209949788a1ced65e9ecf82b4eaa0992a7a1dde1511a3b6e7";
  };

  buildInputs = [
    zlib libxml2 libxslt firefox openssl curl
    glib gtk pkgconfig dbus-glib realCurl pcre libsexy libgnomeui gtkspell libnotify libgtkhtml
  ];

  configureFlags="--with-libcurl-libraries=${curl.out}/lib --with-libcurl-headers=${curl.dev}/include --with-pcre_libraries=${pcre.out}/lib --with-pcre_headers=${pcre.dev}/include";
}
