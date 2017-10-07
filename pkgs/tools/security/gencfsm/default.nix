{ stdenv, fetchurl, autoconf, automake, intltool, libtool, pkgconfig, encfs
, glib , gnome3, gtk3, libgnome_keyring, vala, wrapGAppsHook, xorg
}:

stdenv.mkDerivation rec {
  version = "1.8.18";
  name = "gnome-encfs-manager-${version}";

  src = fetchurl {
    url = "https://launchpad.net/gencfsm/trunk/1.8/+download/gnome-encfs-manager_${version}.tar.xz";
    sha256 = "1rpf683lxa78fmxxb0hnq7vdh3yn7qid2gqq67q9mk65sp9vdhdj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake intltool libtool vala glib encfs
    gtk3 libgnome_keyring gnome3.libgee xorg.libSM xorg.libICE
    wrapGAppsHook ];

  patches = [ ./makefile-mkdir.patch ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--disable-appindicator" ];

  preFixup = ''gappsWrapperArgs+=(--prefix PATH : ${encfs}/bin)'';

  meta = with stdenv.lib; {
    homepage = http://www.libertyzero.com/GEncfsM/;
    downloadPage = https://launchpad.net/gencfsm/;
    description = "EncFS manager and mounter with GNOME3 integration";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.spacefrogg ];
  };
}
