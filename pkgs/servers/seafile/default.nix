{stdenv, fetchurl, which, automake, autoconf, pkgconfig, curl, libtool, libarchive, libevhtp-seafile, vala, python, intltool, fuse, ccnet, acl, attr, lzma, bzip2}:

stdenv.mkDerivation rec
{
  version = "5.1.2";
  name = "seafile-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/seafile/archive/v${version}-server.tar.gz";
    sha256 = "0kj6af695b9mrdfnvgw5zkkslncrqs035q3pna08anpa203vw4xq";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool libarchive libevhtp-seafile vala python intltool fuse ccnet curl acl attr lzma bzip2 ];
  propagatedBuildInputs = [ ccnet ];

  preConfigure = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  configureFlags = "--enable-client --enable-server";

  meta = {
    description = "File syncing and sharing software with file encryption and group sharing, emphasis on reliability and high performance";
    homepage = "https://github.com/haiwen/seafile";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ calrama hhhorn ];
  };
}
