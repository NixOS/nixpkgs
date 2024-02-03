{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook, pkg-config, fuse, util-linux, lz4, zlib
, fuseSupport ? stdenv.isLinux
}:

stdenv.mkDerivation rec {
  pname = "erofs-utils";
  version = "1.7";
  outputs = [ "out" "man" ];

  src = fetchurl {
    url =
      "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-${version}.tar.gz";
    hash = "sha256-tutSm7Qj6y3XecnanCYyhVSItLkeI1U6Mc4j8Rycziw=";
  };

  patches = [
    # Fixes #261394. Can be dropped with the next erofs version.
    (fetchpatch {
      url = "https://github.com/erofs/erofs-utils/commit/8cbc205185a18b9510f4c1fbd54957354f696321.patch";
      hash = "sha256-CQ5hxav5+HGnBVJW66St9FaVgkuqhkv89rjC/4cmXLs=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ util-linux lz4 zlib ]
    ++ lib.optionals fuseSupport [ fuse ];

  configureFlags = [
    "MAX_BLOCK_SIZE=4096"
  ] ++ lib.optional fuseSupport "--enable-fuse";

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/about/";
    description = "Userspace utilities for linux-erofs file system";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ ehmry nikstur ];
    platforms = platforms.unix;
  };
}
