{ lib, stdenv, fetchurl, libX11 }:

stdenv.mkDerivation rec {
  pname = "xosview2";
  version = "2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/xosview/${pname}-${version}.tar.gz";
    sha256 = "sha256-ex1GDBgx9Zzx5tOkZ2IRYskmBh/bUYpRTXHWRoE30vA=";
  };

  # The software failed to buid with this enabled; it seemed tests were not implemented
  doCheck = false;

  buildInputs = [ libX11 ];

  meta = with lib; {
    description = "Lightweight program that gathers information from your operating system and displays it in graphical form";
    longDescription = ''
      xosview is a lightweight program that gathers information from your
      operating system and displays it in graphical form. It attempts to show
      you in a quick glance an overview of how your system resources are being
      utilized.

      It can be configured to be nothing more than a small strip showing a
      couple of parameters on a desktop task bar. Or it can display dozens of
      meters and rolling graphical charts over your entire screen.

      Since xosview renders all graphics with core X11 drawing methods, you can
      run it on one machine and display it on another. This works even if your
      other host is an operating system not running an X server inside a
      virtual machine running on a physically different host. If you can
      connect to it on a network, then you can popup an xosview instance and
      monitor what is going on.
    '';
    homepage = "http://xosview.sourceforge.net/index.html";
    license = with licenses; [ gpl2 bsdOriginal ];
    maintainers = [ maintainers.SeanZicari ];
    platforms = platforms.all;
  };
}
