{ lib, stdenv, fetchgit, libpulseaudio, pkg-config, gtk3, glibc, autoconf, automake, libnotify, libX11, xf86inputevdev }:

stdenv.mkDerivation {
  pname = "pa-applet";
  version = "unstable-2012-04-11";

  src = fetchgit {
    url = "git://github.com/fernandotcl/pa-applet.git";
    rev = "005f192df9ba6d2e6491f9aac650be42906b135a";
    sha256 = "1242sdri67wnm1cd0hr40mxarkh7qs7mb9n2m0g9dbz0f4axj6wa";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3 libpulseaudio glibc automake autoconf libnotify libX11 xf86inputevdev
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  # work around a problem related to gtk3 updates
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postInstall = "";

  meta = with lib; {
    description = "";
    license = licenses.gpl2;
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.linux;
  };
}
