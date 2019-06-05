{ stdenv, fetchurl, libuuid, lzo, zlib, acl }:

stdenv.mkDerivation rec {
  pname = "mtd-utils";
  version = "2.1.0";

  src = fetchurl {
    url = "ftp://ftp.infradead.org/pub/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1ljb8nmfhpj0fyiyi9m5biaflvmf3idc0i4fbq9f9blkdnq9bfdl";
  };

  patchPhase = ''
    sed -i -e s,/usr/local,, -e s,/usr,$out, common.mk
  '';

  buildInputs = [ libuuid lzo zlib acl ];

  meta = {
    description = "Tools for MTD filesystems";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.linux-mtd.infradead.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
