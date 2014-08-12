{stdenv, fetchgit, libuuid, lzo, zlib, acl}:

let
  version = "1.5.0";
in
stdenv.mkDerivation {
  name = "mtd-utils-${version}";

  src = fetchgit {
    url = git://git.infradead.org/mtd-utils.git;
    rev = "refs/tags/v" + version;
    sha256 = "cc645c0ec28083431b11f3b38f9f7759378d89e11047a883529f703e1b6c1cce";
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
