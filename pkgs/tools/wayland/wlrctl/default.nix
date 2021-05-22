{ lib, stdenv, fetchFromSourcehut, cmake, meson, pkg-config, libxkbcommon, wayland, scdoc, ninja }:

stdenv.mkDerivation rec {
  pname = "wlrctl";
  version = "0.2.1";

  src = fetchFromSourcehut {
    owner = "~brocellous";
    repo = "wlrctl";
    rev = "v${version}";
    sha256 = "039cxc82k7x473n6d65jray90rj35qmfdmr390zy0c7ic7vn4b78";
  };
  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake meson pkg-config scdoc ninja ];
  buildInputs = [ libxkbcommon wayland ];

  meta = with lib; {
    description = "Command line utility for miscellaneous wlroots Wayland extensions";
    homepage = "https://git.sr.ht/~brocellous/wlrctl";
    license = licenses.mit;
    maintainers = with maintainers; [ puffnfresh ];
    platforms = platforms.linux;
  };
}
