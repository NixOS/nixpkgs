{ stdenv, fetchurl, makeWrapper, pkg-config
, dbus, dbus-glib, gtk3, gdk-pixbuf, librsvg
, fortune
}:

stdenv.mkDerivation rec {
  pname = "xcowsay";
  version = "1.5";

  src = fetchurl {
    url = "http://www.nickg.me.uk/files/xcowsay-${version}.tar.gz";
    sha256 = "0pyaa062z1ag26dhkm1yzp2hivnlmhlpqn5xg7mx9r1m652mm91y";
  };

  buildInputs = [
    dbus
    dbus-glib
    gtk3
    gdk-pixbuf # loading cow images
    librsvg # dreaming SVG images
  ];

  preConfigure = "
    patchShebangs ./configure
  ";

  nativeBuildInputs = [ makeWrapper pkg-config ];

  configureFlags = [ "--enable-dbus" ];

  postInstall = ''
    for tool in xcowdream xcowsay xcowthink xcowfortune; do
      wrapProgram $out/bin/$tool \
        --prefix PATH : $out/bin:${fortune}/bin
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.doof.me.uk/xcowsay";
    description =
      "A program based on cowsay that displays a cute cow and message on your desktop";
    license = licenses.gpl3;
    maintainers = with maintainers; [ das_j ];
  };
}
