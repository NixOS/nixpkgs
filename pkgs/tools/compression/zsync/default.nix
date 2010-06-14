{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "zsync-0.6.1";

  src = fetchurl {
    url = "http://zsync.moria.org.uk/download/${name}.tar.bz2";
    sha256 = "13rbq2m2d4c4qqzadr1cfzrryqxvjgafr8cmask9w2acc0zpv7v1";
  };

  meta = {
    homepage = http://zsync.moria.org.uk/;
    description = "File distribution system using the rsync algorithm";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
