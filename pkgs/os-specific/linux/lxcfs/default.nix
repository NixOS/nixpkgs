{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, help2man, fuse, pam }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "lxcfs-2.0.7";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxcfs";
    rev = name;
    sha256 = "1z6d52dc12rcplgc9jdgi3lbxm6ahlsjgs1k8v8kvn261xsq1m0a";
  };

  nativeBuildInputs = [ pkgconfig help2man autoreconfHook ];
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
    maintainers = with maintainers; [ mic92 fpletz ];
  };
}
