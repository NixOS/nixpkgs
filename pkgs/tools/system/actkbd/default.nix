{ fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  name = "actkbd-0.2.8";

  src = fetchurl {
    url = "http://users.softlab.ece.ntua.gr/~thkala/projects/actkbd/files/${name}.tar.bz2";
    sha256 = "1ipb7k5q7k7p54is96ij2n74jfa6xc0llb9lpjwxhsqviqxn9slm";
  };

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace /etc $out/etc
  '';

  postInstall = ''
    mkdir -p $out/share/doc/actkbd
    cp -r README samples $out/share/doc/actkbd
  '';

  meta = with lib; {
    description = "A keyboard shortcut daemon";
    longDescription = ''
      actkbd is a simple daemon that binds actions to keyboard events
      directly on evdev interface (that is, no X11 required). It
      recognises key combinations and can handle press, repeat and
      release events.
    '';
    license = licenses.gpl2;
    homepage = "http://users.softlab.ece.ntua.gr/~thkala/projects/actkbd/";
    platforms = platforms.linux;
  };
}
