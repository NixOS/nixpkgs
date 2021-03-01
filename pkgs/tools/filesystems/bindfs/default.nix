{ lib, stdenv, fetchurl, fuse, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.14.9";
  pname = "bindfs";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "0fnij365dn4ihkpfc92x63inxxwpminzffyj55krp1w02canpl5n";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse ];
  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
    description = "A FUSE filesystem for mounting a directory to another location";
    homepage    = "https://bindfs.org";
    license     = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms   = lib.platforms.unix;
  };
}
