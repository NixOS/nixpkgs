{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, fuse, libuuid, lz4 }:

stdenv.mkDerivation rec {
  pname = "erofs-utils";
  version = "1.5";
  outputs = [ "out" "man" ];

  src = fetchgit {
    url =
      "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git";
    rev = "v" + version;
    sha256 = "sha256-vMWAmGMJp0XDuc4sbo6Y7gfCQVAo4rETea0Tkdbg82U=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse libuuid lz4 ];

  configureFlags = [ "--enable-fuse" ];

  meta = with lib; {
    description = "Userspace utilities for linux-erofs file system";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
