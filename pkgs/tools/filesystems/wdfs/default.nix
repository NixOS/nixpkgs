{stdenv, fetchurl, glib, neon, fuse, pkgconfig}:

stdenv.mkDerivation rec
{
  name = "wdfs-fuse-1.4.2";
  src = fetchurl {
    url = "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz";
    sha256 = "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5";
  };
  buildInputs = [fuse glib neon pkgconfig];
  meta = {
    homepage = "http://noedler.de/projekte/wdfs/";
    description = "wdfs a user-space filesystem that allows to mount a webdav share";
  };
}
