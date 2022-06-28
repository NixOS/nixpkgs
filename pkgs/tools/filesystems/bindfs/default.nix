{ lib, stdenv, fetchurl, fuse, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.16.1";
  pname = "bindfs";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-Veo9KqjkjQvqI7fAsDlQz+tJI1W/2Nu4oXOh44PyKLw=";
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
