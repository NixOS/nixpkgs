{ stdenv, lib, fetchurl, gettext, ncurses }:

stdenv.mkDerivation rec {
  pname = "yash";
  version = "2.52";

  src = fetchurl {
    url = "https://osdn.net/dl/yash/yash-${version}.tar.xz";
    sha256 = "sha256:1jdmj4cyzwxxyyqf20y1zi578h7md860ryffp02qi143zpppn4sm";
  };

  strictDeps = true;
  buildInputs = [ gettext ncurses ];

  meta = with lib; {
    description = "Yet another POSIX-compliant shell";
    homepage = "https://yash.osdn.jp/index.html.en";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.all;
  };

  passthru.shellPath = "/bin/yash";
}
