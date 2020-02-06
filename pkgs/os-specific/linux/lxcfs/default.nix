{ config, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, help2man, fuse
, enableDebugBuild ? config.lxcfs.enableDebugBuild or false }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lxcfs-3.1.2";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxcfs";
    rev = name;
    sha256 = "195skz6wc2gfcf99f1fz1yaw29ngzg9lphnkag7yxnk3ffbhv40s";
  };

  nativeBuildInputs = [ pkgconfig help2man autoreconfHook ];
  buildInputs = [ fuse ];

  preConfigure = stdenv.lib.optionalString enableDebugBuild ''
    sed -i 's,#AM_CFLAGS += -DDEBUG,AM_CFLAGS += -DDEBUG,' Makefile.am
  '';

  configureFlags = [
    "--with-init-script=systemd"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [ "SYSTEMD_UNIT_DIR=\${out}/lib/systemd" ];

  postFixup = ''
    # liblxcfs.so is reloaded with dlopen()
    patchelf --set-rpath "$(patchelf --print-rpath "$out/bin/lxcfs"):$out/lib" "$out/bin/lxcfs"
  '';

  meta = {
    homepage = https://linuxcontainers.org/lxcfs;
    description = "FUSE filesystem for LXC";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 fpletz ];
  };
}
