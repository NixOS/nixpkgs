{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  fuse,
  util-linux,
  lz4,
  xz,
  zlib,
  libselinux,
  fuseSupport ? stdenv.isLinux,
  selinuxSupport ? false,
  lzmaSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "erofs-utils";
  version = "1.7.1";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-${version}.tar.gz";
    hash = "sha256-GWCD1j5eIx+1eZ586GqUS7ylZNqrzj3pIlqKyp3K/xU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs =
    [
      util-linux
      lz4
      zlib
    ]
    ++ lib.optionals fuseSupport [ fuse ]
    ++ lib.optionals selinuxSupport [ libselinux ]
    ++ lib.optionals lzmaSupport [ xz ];

  configureFlags =
    [
      "MAX_BLOCK_SIZE=4096"
    ]
    ++ lib.optional fuseSupport "--enable-fuse"
    ++ lib.optional selinuxSupport "--with-selinux"
    ++ lib.optional lzmaSupport "--enable-lzma";

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/about/";
    description = "Userspace utilities for linux-erofs file system";
    changelog = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/tree/ChangeLog?h=v${version}";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [
      ehmry
      nikstur
    ];
    platforms = platforms.unix;
  };
}
