{ stdenv, fetchurl, pkgconfig, help2man, fuse, pam }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lxcfs-${version}";
  version = "2.0.4";

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/lxcfs/lxcfs-${version}.tar.gz";
    sha256 = "0pfrsn7hqccpcnwg4xk8ds0avb2yc9gyvj7bk2bl90vpwsm35j7y";
  };

  nativeBuildInputs = [ pkgconfig help2man ];
  buildInputs = [ fuse pam ];

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
    maintainers = with maintainers; [ mic92 ];
  };
}
