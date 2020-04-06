{ stdenv, fetchurl, fuse, pkgconfig }:

stdenv.mkDerivation rec {
  version = "1.14.4";
  pname = "bindfs";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "1vk42bq8y13gv4yvajf65qsh59lscwcaw3xv94qpjxld3786i8c7";
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
