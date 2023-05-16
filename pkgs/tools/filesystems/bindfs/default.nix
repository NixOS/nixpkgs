<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, pkg-config
, fuse
, fuse3
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.17.4";
  pname = "bindfs";

  src = fetchurl {
    url = "https://bindfs.org/downloads/bindfs-${finalAttrs.version}.tar.gz";
    hash = "sha256-b9Svm6LsK9tgPvjuoqnRLbLl/py+UrhkC0FXNKWfPcw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = if stdenv.isDarwin then [ fuse ] else [ fuse3 ];

=======
{ lib, stdenv, fetchurl, fuse, fuse3, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.17.2";
  pname = "bindfs";

  src = fetchurl {
    url    = "https://bindfs.org/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-XyxQpwuNWMAluB+/Nk+tQy0VSTZjDOACPMiLqo1codA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin then [ fuse ] else [ fuse3 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/mpartel/bindfs/raw/${finalAttrs.version}/ChangeLog";
    description = "A FUSE filesystem for mounting a directory to another location";
    homepage = "https://bindfs.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lovek323 lovesegfault ];
    platforms = lib.platforms.unix;
  };
})
=======
    description = "A FUSE filesystem for mounting a directory to another location";
    homepage    = "https://bindfs.org";
    license     = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lovek323 lovesegfault ];
    platforms   = lib.platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
