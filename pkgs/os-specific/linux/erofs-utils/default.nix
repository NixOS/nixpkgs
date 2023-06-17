{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, fuse, libuuid, lz4 }:

stdenv.mkDerivation rec {
  pname = "erofs-utils";
  version = "1.6";
  outputs = [ "out" "man" ];

  src = fetchurl {
    url =
      "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-${version}.tar.gz";
    sha256 = "sha256-2/Gtrv8buFMrKacsip4ZGTjJOJlGdw3HY9PFnm8yBXE=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse libuuid lz4 ];

  configureFlags = [ "--enable-fuse" ];

  meta = with lib; {
    description = "Userspace utilities for linux-erofs file system";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
