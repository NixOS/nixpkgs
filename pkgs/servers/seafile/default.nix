{stdenv, fetchurl, which, automake, autoconf, pkgconfig, curl, libtool, libarchive, libevhtp-seafile, vala, python, intltool, fuse, ccnet, acl, attr, lzma, bzip2, makeWrapper}:

stdenv.mkDerivation rec
{
  version = "5.1.4";
  name = "seafile-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/seafile/archive/v${version}-server.tar.gz";
    sha256 = "06b97qb56qsnw93fjrdaglmfll2mvf0s8jh96i53smjjqa5jsnxl";
  };

  buildInputs = [ which automake autoconf pkgconfig libtool libarchive libevhtp-seafile vala python intltool fuse ccnet curl acl attr lzma bzip2 makeWrapper];
  propagatedBuildInputs = [ ccnet ];

  preConfigure = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  configureFlags = "--enable-client --enable-server";

  postInstall = ''
    wrapProgram $out/bin/seaf-cli \
      --set PYTHONPATH "$PYTHONPATH:$(toPythonPath $out)" \
      --set PATH "${ccnet}/bin:$out/bin"
    wrapProgram $out/bin/seafile-admin \
      --set PATH "${ccnet}/bin:$out/bin"
    wrapProgram $out/bin/seafile-controller \
      --set PATH "${ccnet}/bin:$out/bin"
  '';

  meta = {
    description = "File syncing and sharing software with file encryption and group sharing, emphasis on reliability and high performance";
    homepage = "https://github.com/haiwen/seafile";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ calrama hhhorn ];
  };
}
