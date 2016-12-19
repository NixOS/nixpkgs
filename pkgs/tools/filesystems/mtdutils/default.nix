{ stdenv, fetchurl, libuuid, lzo, zlib, acl }:

stdenv.mkDerivation rec {
  name = "mtd-utils-${version}";
  version = "1.5.2";

  src = fetchurl {
    url = ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-1.5.2.tar.bz2;
    sha256 = "007lhsd8yb34l899r4m37whhzdw815cz4fnjbpnblfha524p7dax";
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
