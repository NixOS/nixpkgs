{ stdenv, fetchurl, pkgconfig, openobex, bluez, cmake }:
   
stdenv.mkDerivation rec {
  name = "obexftp-0.24";
   
  src = fetchurl {
    url = "mirror://sourceforge/openobex/${name}-Source.tar.gz";
    sha256 = "0szy7p3y75bd5h4af0j5kf0fpzx2w560fpy4kg3603mz11b9c1xr";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ bluez ];

  propagatedBuildInputs = [ openobex ];

  # There's no such thing like "bluetooth" library; possibly they meant "bluez" but it links correctly without this.
  postFixup = ''
    sed -i 's,^Requires: bluetooth,Requires:,' $out/lib/pkgconfig/obexftp.pc
  '';

  meta = with stdenv.lib; {
    homepage = http://dev.zuckschwerdt.org/openobex/wiki/ObexFtp;
    description = "A library and tool to access files on OBEX-based devices (such as Bluetooth phones)";
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
