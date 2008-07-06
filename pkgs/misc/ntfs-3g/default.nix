args: with args;
stdenv.mkDerivation rec {
  pname = "ntfs-3g";
  version = "1.2531";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "e5d834f0be7efdedc36e45808554dafcb53f70b2fa2d511df5b9ae23e6807bbe";
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
