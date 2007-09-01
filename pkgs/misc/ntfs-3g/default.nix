args: with args;
stdenv.mkDerivation {
  name = "ntfs3g-1.810";
  src = fetchurl {
    url = http://www.ntfs-3g.org/ntfs-3g-1.810.tgz;
    sha256 = "14hly6i8b6lh1z54prhml1lf457r0dm8ild0ziqxnnp22s6ydqgy";
  };
  buildInputs = [fuse pkgconfig];
  preConfigure="sed -e 's:/sbin:@sbindir@:' -i src/Makefile.in";
  configureFlags="--enable-shared --disable-static --exec-prefix=\${prefix}";

  meta = {
	  description = "FUSE-base ntfs driver with full write support";
  };
}
