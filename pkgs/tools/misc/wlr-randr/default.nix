{ stdenv, fetchFromGitHub, meson, ninja, cmake, pkgconfig, wayland }:

stdenv.mkDerivation rec {
  pname = "wlr-randr";
  version = "unstable-2019-03-21";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "c4066aa3249963dc7877119cffce10f3fa8b6304";
    sha256 = "1ahw4sv07xg5rh9vr7j28636iaxs06vnybm3li6y8dz2sky7hk88";
  };

  nativeBuildInputs = [ meson ninja cmake pkgconfig ];
  buildInputs = [ wayland ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    description = "An xrandr clone for wlroots compositors";
    homepage = "https://github.com/emersion/wlr-randr";
    maintainers = with maintainers; [ ma27 ];
  };
}
