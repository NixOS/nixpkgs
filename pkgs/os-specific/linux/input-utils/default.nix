{ lib, stdenv, fetchurl, linuxHeaders }:

stdenv.mkDerivation rec {
  pname = "input-utils";
  version = "1.3";

  src = fetchurl {
    url = "https://www.kraxel.org/releases/input/input-${version}.tar.gz";
    sha256 = "11w0pp20knx6qpgzmawdbk1nj2z3fzp8yd6nag6s8bcga16w6hli";
  };

  prePatch = ''
    # Use proper include path for kernel include files.
    substituteInPlace ./name.sh --replace "/usr/include/linux/" "${linuxHeaders}/include/linux/"
    substituteInPlace ./lirc.sh --replace "/usr/include/linux/" "${linuxHeaders}/include/linux/"
  '';

  makeFlags = [
    "prefix=$(out)"
    "STRIP="
  ];

  meta = with lib; {
    description = "Input layer utilities, includes lsinput";
    homepage    = "https://www.kraxel.org/blog/linux/input/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ samueldr ];
    platforms   = platforms.linux;
  };
}
