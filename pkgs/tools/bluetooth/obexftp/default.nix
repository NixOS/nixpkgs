{stdenv, fetchurl, pkgconfig, openobex, bluez}:
   
stdenv.mkDerivation rec {
  name = "obexftp-0.23";
   
  src = fetchurl {
    url = "mirror://sourceforge/openobex/${name}.tar.bz2";
    sha256 = "0djv239b14p221xjxzza280w3pnnwzpw4ssd6mshz36ki3r4z9s4";
  };

  buildInputs = [pkgconfig bluez];

  propagatedBuildInputs = [openobex];

  meta = {
    homepage = http://dev.zuckschwerdt.org/openobex/wiki/ObexFtp;
    description = "A library and tool to access files on OBEX-based devices (such as Bluetooth phones)";
    platforms = stdenv.lib.platforms.linux;
  };
}
