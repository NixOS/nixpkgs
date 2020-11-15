{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "zsync-0.6.2";

  src = fetchurl {
    url = "http://zsync.moria.org.uk/download/${name}.tar.bz2";
    sha256 = "1wjslvfy76szf0mgg2i9y9q30858xyjn6v2acc24zal76d1m778b";
  };

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  meta = {
    homepage = "http://zsync.moria.org.uk/";
    description = "File distribution system using the rsync algorithm";
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
