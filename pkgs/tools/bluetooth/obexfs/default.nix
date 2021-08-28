{ lib, stdenv, fetchurl, pkg-config, bluez, fuse, obexftp }:

stdenv.mkDerivation rec {
  name = "obexfs-0.12";

  src = fetchurl {
    url = "mirror://sourceforge/openobex/${name}.tar.gz";
    sha256 = "1g3krpygk6swa47vbmp9j9s8ahqqcl9ra8r25ybgzv2d9pmjm9kj";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse obexftp bluez ];

  meta = with lib; {
    homepage = "http://dev.zuckschwerdt.org/openobex/wiki/ObexFs";
    description = "A tool to mount OBEX-based devices (such as Bluetooth phones)";
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
