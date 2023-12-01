{ lib
, stdenv
, fetchurl
, pkg-config
, fuse
, fuse3
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.17.5";
  pname = "bindfs";

  src = fetchurl {
    url = "https://bindfs.org/downloads/bindfs-${finalAttrs.version}.tar.gz";
    hash = "sha256-Wj2xu7soSOtDqzapI8mVgx0xmAd/2J6VHbXQt55i2mQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = if stdenv.isDarwin then [ fuse ] else [ fuse3 ];

  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
    changelog = "https://github.com/mpartel/bindfs/raw/${finalAttrs.version}/ChangeLog";
    description = "A FUSE filesystem for mounting a directory to another location";
    homepage = "https://bindfs.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lovek323 lovesegfault ];
    platforms = lib.platforms.unix;
  };
})
