{ stdenv, fetchgit, pulseaudio, pkgconfig, gtk3, glibc, autoconf, automake, libnotify, libX11, xf86inputevdev }:

stdenv.mkDerivation rec {
  name = "pa-applet";

  src = fetchgit {
    url = "git://github.com/fernandotcl/pa-applet.git";
    rev = "005f192df9ba6d2e6491f9aac650be42906b135a";
    sha256 = "1rqnp6nzgb3z7c6pvd5qzsxprwrzif8cfx6i7xp3f0x5s7n2dqkb";
  };

  buildInputs = [
    gtk3 pulseaudio glibc pkgconfig automake autoconf libnotify libX11 xf86inputevdev
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  # work around a problem related to gtk3 updates
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postInstall = ''
  '';

  meta = with stdenv.lib; {
    description = "";
    license = licenses.gpl2;
    maintainers = with maintainers; [ iElectric ];
    platforms = platforms.linux;
  };
}
