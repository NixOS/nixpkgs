args: with args;
stdenv.mkDerivation {
  name = "ntfs3g-1.826";
  src = fetchurl {
    url = http://www.ntfs-3g.org/ntfs-3g-1.826.tgz;
    sha256 = "0anxg4nzhc8d8wvxgw78bc2pb2ciim8mflxgcac9p8d3djwdsxyp";
  };
  buildInputs = [fuse pkgconfig];
  preConfigure="sed -e 's:/sbin:@sbindir@:' -i src/Makefile.in";
  configureFlags="--enable-shared --disable-static --disable-ldconfig --exec-prefix=\${prefix}";

  meta = {
    description = "FUSE-base ntfs driver with full write support";
  };
}
