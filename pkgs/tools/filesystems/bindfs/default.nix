{ stdenv, fetchurl, fuse, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.14.0";
  name    = "bindfs-${version}";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${name}.tar.gz";
    sha256 = "1f1znixdaz4wnr9j6rkrplhbnkz7pdw9927yfikbjvxz8cl6qsdz";
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
