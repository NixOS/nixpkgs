{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, help2man, fuse, pam }:

with stdenv.lib;
stdenv.mkDerivation rec {
  # use unstable because it fixed some serious crashes,
  # stable should be reconsidered in future
  name = "lxcfs-unstable-2017-03-02";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxcfs";
    sha256 = "1say5bf6gknzs0aymvrg2xiypc311gcdcfdmvb2vnz058pmianq9";
    rev = "4a6707e130b4b65a33606ebc18a95ec471f4bf40";
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
    maintainers = with maintainers; [ mic92 ];
  };
}
