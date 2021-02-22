{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, fuse, libuuid, lz4 }:

stdenv.mkDerivation rec {
  pname = "erofs-utils";
  version = "1.2.1";
  outputs = [ "out" "man" ];

  src = fetchgit {
    url =
      "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git";
    rev = "v" + version;
    sha256 = "1vb4mxsb59g29x7l22cffsqa8x743sra4j5zbmx89hjwpwm9vvcg";
  };

  buildInputs = [ autoreconfHook pkg-config fuse libuuid lz4 ];

  configureFlags = [ "--enable-fuse" ];

  meta = with lib; {
    description = "Userspace utilities for linux-erofs file system";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
