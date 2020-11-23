{ stdenv, fetchurl, fuse, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.14.8";
  pname = "bindfs";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "15y4brlcrqhxl6z73785m0dr1vp2q3wc6xss08x9jjr0apzmmjp5";
  };

  dontStrip = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse ];
  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
    description = "A FUSE filesystem for mounting a directory to another location";
    homepage    = "https://bindfs.org";
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
