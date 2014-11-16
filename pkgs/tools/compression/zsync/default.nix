{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "zsync-0.6.2";

  src = fetchurl {
    url = "http://zsync.moria.org.uk/download/${name}.tar.bz2";
    sha1 = "5e69f084c8adaad6a677b68f7388ae0f9507617a";
  };

  meta = {
    homepage = http://zsync.moria.org.uk/;
    description = "File distribution system using the rsync algorithm";
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
