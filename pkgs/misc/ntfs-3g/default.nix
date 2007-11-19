args: with args;
stdenv.mkDerivation rec {
  name = "ntfs-3g-1.1104";
  src = fetchurl {
    url = "${meta.homepage}/${name}.tgz";
    sha256 = "1m96c3vxm051lpy3kyik9s0m390rj6ngm11xmahfhw61794jzbyp";
  };
  buildInputs = [fuse pkgconfig];
  preConfigure="sed -e 's:/sbin:@sbindir@:' -i src/Makefile.in";
  configureFlags="--enable-shared --disable-static --disable-ldconfig --exec-prefix=\${prefix}";

  meta = {
    homepage = http://www.ntfs-3g.org;
    description = "FUSE-base ntfs driver with full write support";
  };
}
