{stdenv, fetchgit, libuuid, lzo, zlib, acl}:

let
  version = "v1.3.1";
in
stdenv.mkDerivation {
  name = "mtd-utils-${version}";

  src = fetchgit {
    url = git://git.infradead.org/mtd-utils.git;
    rev = version;
    sha256 = "0pjjs9x03bgvphqwlw99c2cpkpjsx0vkqi79vjl7fcb9pyrghgd1";
  };

  preBuild = ''
    makeFlags="DESTDIR=$out"
  '';

  buildInputs = [ libuuid lzo zlib acl ];

  meta = {
    description = "Tools for MTD filesystems";
    license = "GPLv2+";
    homepage = http://www.linux-mtd.infradead.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
