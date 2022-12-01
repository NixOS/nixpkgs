{ lib, stdenv, fetchurl, makeWrapper, pkg-config
, dbus, dbus-glib, gtk3, gdk-pixbuf, librsvg
, fortune
}:

stdenv.mkDerivation rec {
  pname = "xcowsay";
  version = "1.6";

  src = fetchurl {
    url = "http://www.nickg.me.uk/files/xcowsay-${version}.tar.gz";
    sha256 = "sha256-RqzoZP8o0tIfS3BY8CleGNAEGhIMEHipUfpDxOD1yMU=";
  };

  buildInputs = [
    dbus
    dbus-glib
    gtk3
    gdk-pixbuf # loading cow images
    librsvg # dreaming SVG images
  ];
  nativeBuildInputs = [ makeWrapper pkg-config ];

  configureFlags = [ "--enable-dbus" ];

  postInstall = ''
    for tool in xcowdream xcowsay xcowthink xcowfortune; do
      wrapProgram $out/bin/$tool \
        --prefix PATH : $out/bin:${fortune}/bin
    done
  '';

  meta = with lib; {
    homepage = "http://www.doof.me.uk/xcowsay";
    description = "Tool to display a cute cow and messages";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ das_j ];
  };
}
