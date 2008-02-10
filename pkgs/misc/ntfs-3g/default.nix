args: with args;
stdenv.mkDerivation rec {
  name = "ntfs-3g-1.2129";
  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "00fqg39m5myi46kgsssxmpya6g8y32z6ggqc2snjrv0znfg3009i";
  };
  buildInputs = [fuse pkgconfig];
  preConfigure="sed -e 's:/sbin:@sbindir@:' -i src/Makefile.in";
  configureFlags="--enable-shared --disable-static --disable-ldconfig --exec-prefix=\${prefix}";

  meta = {
    homepage = http://www.ntfs-3g.org;
    description = "FUSE-base ntfs driver with full write support";
  };
}
