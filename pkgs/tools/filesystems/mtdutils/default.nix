{stdenv, fetchgit, libuuid, lzo, zlib, acl}:

let
  version = "1.3.1";
in
stdenv.mkDerivation {
  name = "mtd-utils-${version}";

  src = fetchgit {
    url = git://git.infradead.org/mtd-utils.git;
    rev = "v" + version;
    sha256 = "0pjjs9x03bgvphqwlw99c2cpkpjsx0vkqi79vjl7fcb9pyrghgd1";
  };

  patchPhase = ''
    sed -i -e s,/usr/local,, -e s,/usr,$out, common.mk

    # gcc 4.5.1 issues a warning where 4.4.3 did not
    sed -i -e s/-Werror// ubi-utils/old-utils/Makefile
  '';

  buildInputs = [ libuuid lzo zlib acl ];

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  meta = {
    description = "Tools for MTD filesystems";
    license = "GPLv2+";
    homepage = http://www.linux-mtd.infradead.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
