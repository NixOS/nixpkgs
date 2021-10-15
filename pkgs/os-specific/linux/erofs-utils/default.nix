{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, fuse, libuuid, lz4 }:

stdenv.mkDerivation rec {
  pname = "erofs-utils";
  version = "1.3";
  outputs = [ "out" "man" ];

  src = fetchgit {
    url =
      "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git";
    rev = "v" + version;
    sha256 = "0sqiw05zbxr6l0g9gn3whkc4qc5km2qvfg4lnm08nppwskm8yaw8";
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
