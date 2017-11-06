{ stdenv, fetchurl, libX11 }:

stdenv.mkDerivation rec {
  name = "xosview2-${version}";
  version = "2.2.2";

  src = fetchurl {
    url = "mirror://sourceforge.net/xosview/${name}.tar.gz";
    sha256 = "3502e119a5305ff2396f559340132910807351c7d4e375f13b5c338404990406";
  };

  # The software failed to buid with this enabled; it seemed tests were not implemented
  doCheck = false;

  buildInputs = [ libX11 ];

  meta = with stdenv.lib; {
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
    license = licenses.gpl1;
    maintainers = [ maintainers.SeanZicari ];
    platforms = platforms.all;
  };
}
