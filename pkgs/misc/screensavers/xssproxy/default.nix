{ stdenv, fetchFromGitHub, glib, pkgconfig, xorg, dbus }:

let rev = "1.0.0"; in

stdenv.mkDerivation {
  name = "xssproxy-${rev}";

  src = fetchFromGitHub {
    owner = "timakro";
    repo = "xssproxy";
    rev = "v${rev}";
    sha256 = "0c83wmipnsdnbihc5niyczs7jrkss2s8n6iwwjdia7hkjzbd0hl7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib xorg.libX11 xorg.libXScrnSaver dbus ];

  makeFlags = [
    "bindir=$(out)/bin"
    "man1dir=$(out)/share/man/man1"
  ];

  meta = {
    description = "Forward freedesktop.org Idle Inhibition Service calls to Xss";
    homepage = "https://github.com/timakro/xssproxy";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ benley ];
    platforms = stdenv.lib.platforms.unix;
  };
}
