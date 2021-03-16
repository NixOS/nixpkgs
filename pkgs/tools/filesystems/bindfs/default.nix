{ lib, stdenv, fetchurl, fuse, pkg-config, osxfuse }:

stdenv.mkDerivation rec {
  version = "1.15.1";
  pname = "bindfs";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-BN01hKbN+a9DRNQDxiGFyp+rMc465aJdAQG8EJNsaKs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
                then [ osxfuse ]
                else [ fuse ];
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
