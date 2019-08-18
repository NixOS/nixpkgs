{ stdenv, fetchurl, fuse, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.14.1";
  pname = "bindfs";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "111i4ba4px3idmrr5qhgq01926fas1rs2yx2shnwgdk3ziqcszxl";
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
