{ stdenv, lib, fetchurl, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "yash";
  version = "2.52";

  src = fetchurl {
    url = "https://osdn.net/dl/yash/yash-${version}.tar.xz";
    hash = "sha256-VRN77/2DhIgFuM75DAxq9UB0SvzBA+Gw973z7xmRtck=";
  };

  strictDeps = true;
  buildInputs = [ gettext ncurses ];

  meta = with lib; {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.all;
  };

  passthru.shellPath = "/bin/yash";
}
