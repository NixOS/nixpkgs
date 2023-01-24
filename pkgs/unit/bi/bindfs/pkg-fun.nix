{ lib, stdenv, fetchurl, fuse, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.17.1";
  pname = "bindfs";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-7bSYkUTSj3Wv/E9bGAdPuXpY1u41rWkZrHXraky/41I=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse ];
  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
    description = "A FUSE filesystem for mounting a directory to another location";
    homepage    = "https://bindfs.org";
    license     = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lovek323 lovesegfault ];
    platforms   = lib.platforms.unix;
  };
}
