{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, fuse, util-linux, lz4, zlib
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

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ util-linux lz4 zlib ]
    ++ lib.optionals fuseSupport [ fuse ];

  configureFlags = lib.optionals fuseSupport [ "--enable-fuse" ];

  meta = with lib; {
    description = "Userspace utilities for linux-erofs file system";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ ehmry nikstur ];
    platforms = platforms.unix;
  };
}
