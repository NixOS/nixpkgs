{ stdenv, fetchgit, pulseaudio, pkgconfig, gtk3, glibc, autoconf, automake, libnotify, libX11, xf86inputevdev }:

stdenv.mkDerivation rec {
  name = "pa-applet";

  src = fetchgit {
    url = "https://github.com/fernandotcl/pa-applet.git";
    rev = "005f192df9ba6d2e6491f9aac650be42906b135a";
  };

  buildInputs = [
    gtk3 pulseaudio glibc pkgconfig automake autoconf libnotify libX11 xf86inputevdev
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  postInstall = ''
  '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "";
    license = licenses.gpl2;
    maintainers = with maintainers; [ iElectric ];
    platforms = platforms.linux;
  };
}
