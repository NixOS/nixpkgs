{ lib, stdenv, fetchFromGitHub, glib, pkg-config, xorg, dbus }:

stdenv.mkDerivation rec {
  pname = "xssproxy";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "vincentbernat";
    repo = "xssproxy";
    rev = "v${version}";
    sha256 = "sha256-BE/v1CJAwKwxlK3Xg3ezD+IXyT7ZFGz3bQzGxFQfEnU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib xorg.libX11 xorg.libXScrnSaver dbus ];

  makeFlags = [
    "bindir=$(out)/bin"
    "man1dir=$(out)/share/man/man1"
  ];

  meta = {
    description = "Forward freedesktop.org Idle Inhibition Service calls to Xss";
    homepage = "https://github.com/vincentbernat/xssproxy";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
  };
}
