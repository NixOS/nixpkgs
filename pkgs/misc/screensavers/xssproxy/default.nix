{ lib, stdenv, fetchFromGitHub, glib, pkg-config, xorg, dbus }:

stdenv.mkDerivation rec {
  pname = "xssproxy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "timakro";
    repo = "xssproxy";
    rev = "v${version}";
    sha256 = "0c83wmipnsdnbihc5niyczs7jrkss2s8n6iwwjdia7hkjzbd0hl7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib xorg.libX11 xorg.libXScrnSaver dbus ];

  makeFlags = [
    "bindir=$(out)/bin"
    "man1dir=$(out)/share/man/man1"
  ];

  meta = {
    description = "Forward freedesktop.org Idle Inhibition Service calls to Xss";
    homepage = "https://github.com/timakro/xssproxy";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
  };
}
