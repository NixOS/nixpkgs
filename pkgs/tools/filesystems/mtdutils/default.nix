{stdenv, fetchgit, libuuid, lzo, zlib, acl}:

stdenv.mkDerivation rec {
  name = "mtd-utils-${version}";
  version = "1.5.1";

  src = fetchgit {
    url = git://git.infradead.org/mtd-utils.git;
    rev = "refs/tags/v" + version;
    sha256 = "1bjx42pwl789ara63c672chvgvmqhkj4y132gajqih6naq71f8g7";
  };

  patchPhase = ''
    sed -i -e s,/usr/local,, -e s,/usr,$out, common.mk
  '';

  buildInputs = [ libuuid lzo zlib acl ];

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  meta = {
    description = "Tools for MTD filesystems";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.linux-mtd.infradead.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
