{ stdenv, fetchgit, autoreconfHook, pkgconfig, fuse, libuuid, lz4 }:

stdenv.mkDerivation rec {
  pname = "erofs-utils";
  version = "1.2";
  outputs = [ "out" "man" ];

  src = fetchgit {
    url =
      "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git";
    rev = "v" + version;
    sha256 = "07hvijq2hsn3gg1kb8abrfk23n83j57yx8kyv4wqgwhhvd30myjc";
  };

  buildInputs = [ autoreconfHook pkgconfig fuse libuuid lz4 ];

  configureFlags = [ "--enable-fuse" ];

  meta = with stdenv.lib; {
    description = "Userspace utilities for linux-erofs file system";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
