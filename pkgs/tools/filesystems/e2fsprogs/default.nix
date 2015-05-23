{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, libuuid
}:

with stdenv;
let
  optLibuuid = shouldUsePkg libuuid;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "e2fsprogs-1.42.13";

  src = fetchurl {
    url = "mirror://sourceforge/e2fsprogs/${name}.tar.gz";
    sha256 = "1m72lk90b5i3h9qnmss6aygrzyn8x2avy3hyaq2fb0jglkrkz6ar";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ optLibuuid ];

  configureFlags = [
    (mkEnable true                 "symlink-install"           null)
    (mkEnable true                 "relative-symlinks"         null)
    (mkEnable true                 "symlink-relative-symlinks" null)
    (mkEnable false                "compression"               null)
    (mkEnable true                 "htree"                     null)
    (mkEnable true                 "elf-shlibs"                null)
    (mkEnable false                "profile"                   null)
    (mkEnable false                "gcov"                      null)
    (mkEnable false                "jbd-debug"                 null)
    (mkEnable false                "blkid-debug"               null)
    (mkEnable false                "testio-debug"              null)
    (mkEnable (optLibuuid == null) "libuuid"                   null)
    (mkEnable (optLibuuid == null) "libblkid"                  null)
    (mkEnable true                 "quota"                     null)
    (mkEnable false                "backtrace"                 null)
    (mkEnable false                "debugfs"                   null)
    (mkEnable true                 "imager"                    null)
    (mkEnable true                 "resizer"                   null)
    (mkEnable true                 "defrag"                    null)
    (mkEnable true                 "fsck"                      null)
    (mkEnable false                "e2initrd-helper"           null)
    (mkEnable true                 "tls"                       null)
    (mkEnable false                 "uuidd"                    null)  # Build is broken in 1.42.13
  ];

  enableParallelBuilding = true;

  installFlags = [
    "LN=ln -s"
  ];

  postInstall = ''
    make install-libs
  '';

  meta = with stdenv.lib; {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eelco wkennington ];
  };
}
