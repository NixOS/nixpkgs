args: with args;
stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "1.2712";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "01rdx3mzp12pbi3q9l279z78w155fh5axaksxmm3xl9m9ljy4c9j";
  };

  buildInputs = [fuse pkgconfig utillinux];

  preConfigure="
    sed -e 's:/sbin:@sbindir@:' -i src/Makefile.in
    sed -e 's:/bin/mount:${utillinux}/bin/mount:' -i libfuse-lite/mount_util.c
    sed -e 's:/bin/umount:${utillinux}/bin/umount:' -i libfuse-lite/mount_util.c
  ";

  configureFlags="--enable-shared --disable-static --disable-ldconfig --exec-prefix=\${prefix}";

  meta = {
    homepage = http://www.ntfs-3g.org;
    description = "FUSE-base ntfs driver with full write support";
  };
}
