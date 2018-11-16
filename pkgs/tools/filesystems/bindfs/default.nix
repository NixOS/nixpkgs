{ stdenv, fetchurl, fuse, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.13.10";
  name    = "bindfs-${version}";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${name}.tar.gz";
    sha256 = "14wfp2dcjm0f1pmqqvkf94k7pijbi8ka395cm3hryqpi4k0w3f4j";
  };

  dontStrip = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse ];
  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
    description = "A FUSE filesystem for mounting a directory to another location";
    homepage    = https://bindfs.org;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
