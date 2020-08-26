{ stdenv, fetchFromGitHub, meson, ninja, cmake, pkgconfig, wayland }:

stdenv.mkDerivation rec {
  pname = "wlr-randr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "10c8zzp78s5bw34vvjhilipa28bsdx3jbyhnxgp8f8kawh3cvgsc";
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
