{ stdenv, fetchFromGitHub, autoconf, automake, intltool, pkgconfig,
gtk3, connman, openconnect, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "connman-gtk-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jgke";
    repo = "connman-gtk";
    rev = "v${version}";
    sha256 = "09k0hx5hxpbykvslv12l2fq9pxdwpd311mxj038hbqzjghcyidyr";
  };

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    openconnect
    connman
  ];

  preConfigure = ''
    # m4/intltool.m4 is an invalid symbolic link
    rm m4/intltool.m4
    ln -s ${intltool}/share/aclocal/intltool.m4 m4/
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "GTK GUI for Connman";
    homepage = https://github.com/jgke/connman-gtk;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
