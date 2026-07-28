{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  lvm2,
}:

stdenv.mkDerivation rec {
  pname = "dmraid";
  version = "1.0.0.rc16";

  src = fetchurl {
    url = "https://people.redhat.com/~heinzm/sw/dmraid/src/old/dmraid-${version}.tar.bz2";
    sha256 = "0m92971gyqp61darxbiri6a48jz3wq3gkp8r2k39320z0i6w8jgq";
  };

  patches = [
    ./hardening-format.patch
    ./fix-dmevent_tool.patch

    # Fix build with gcc15, based on
    # https://gitlab.alpinelinux.org/alpine/aports/-/raw/dc5b3135517ede55f5e3530e538ca75048d26565/main/dmraid/008-gcc15.patch
    ./dmraid-fix-build-with-gcc15.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/fceed4b8e96b3c1da07babf6f67b6ed1588a28b2/srcpkgs/dmraid/patches/006-musl-libc.patch";
      sha256 = "1j8xda0fpz8lxjxnqdidy7qb866qrzwpbca56yjdg6vf4x21hx6w";
      stripLen = 2;
      extraPrefix = "1.0.0.rc16/";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/fceed4b8e96b3c1da07babf6f67b6ed1588a28b2/srcpkgs/dmraid/patches/007-fix-loff_t-musl.patch";
      sha256 = "0msnq39qnzg3b1pdksnz1dgqwa3ak03g41pqh0lw3h7w5rjc016k";
      stripLen = 2;
      extraPrefix = "1.0.0.rc16/";
    })
  ];

  postPatch = ''
    sed -i 's/\[\[[^]]*\]\]/[ "''$''${n##*.}" = "so" ]/' */lib/Makefile.in
  ''
  + lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -D_GNU_SOURCE"
  '';

  preConfigure = "cd */";

  buildInputs = [ lvm2 ];

  # Hand-written Makefile does not have full dependencies to survive
  # parallel build:
  #   tools/dmraid.c:12:10: fatal error: dmraid/dmraid.h: No such file
  enableParallelBuilding = false;

  meta = {
    description = "Old-style RAID configuration utility";
    longDescription = ''
      Old RAID configuration utility (still under development, though).
      It is fully compatible with modern kernels and mdadm recognizes
      its volumes. May be needed for rescuing an older system or nuking
      the metadata when reformatting.
    '';
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
