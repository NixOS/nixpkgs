{ lib, stdenv, fetchFromGitHub, pkg-config, gtk3, gtk-layer-shell, pam, scdoc }:

stdenv.mkDerivation rec {
  pname = "gtklock";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = "gtklock";
    rev = "v${version}";
    sha256 = "6catuQ4AP3TuAmI8+YSKGV0eOrm+E7rEFWBoC4oDx0s=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 gtk-layer-shell pam scdoc ];

  installPhase = ''
    DESTDIR=$out PREFIX="" make install
  '';

  meta = with lib; {
    description = "GTK-based lockscreen for Wayland";
    homepage = "https://github.com/jovanlanik/gtklock#readme";
    license = licenses.gpl3;
    maintainers = with maintainers; [ danth ];
  };
}
