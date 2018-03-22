{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, help2man, fuse, pam
, enableDebugBuild ? false }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lxcfs-2.0.8";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxcfs";
    rev = name;
    sha256 = "04dzn6snqgw0znf7a7qdm64400jirip6q8amcx5fmz4705qdqahc";
  };

  nativeBuildInputs = [ pkgconfig help2man autoreconfHook ];
  buildInputs = [ fuse pam ];

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
