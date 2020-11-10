{ config, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, help2man, fuse
, utillinux, makeWrapper
, enableDebugBuild ? config.lxcfs.enableDebugBuild or false }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "lxcfs";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxcfs";
    rev = "lxcfs-${version}";
    sha256 = "1fp2q4y3ql4xd2lp4bpcl8s6xryr5xbb56da9d20w2cdr2d0lwyv";
  };

  nativeBuildInputs = [ pkgconfig help2man autoreconfHook ];
  buildInputs = [ fuse makeWrapper ];

  preConfigure = stdenv.lib.optionalString enableDebugBuild ''
    sed -i 's,#AM_CFLAGS += -DDEBUG,AM_CFLAGS += -DDEBUG,' Makefile.am
  '';

  configureFlags = [
    "--with-init-script=systemd"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [ "SYSTEMD_UNIT_DIR=\${out}/lib/systemd" ];

  postInstall = ''
    # `mount` hook requires access to the `mount` command from `utillinux`:
    wrapProgram "$out/share/lxcfs/lxc.mount.hook" \
      --prefix PATH : "${utillinux}/bin"
  '';

  postFixup = ''
    # liblxcfs.so is reloaded with dlopen()
    patchelf --set-rpath "$(patchelf --print-rpath "$out/bin/lxcfs"):$out/lib" "$out/bin/lxcfs"
  '';

  meta = {
    description = "FUSE filesystem for LXC";
    homepage = "https://linuxcontainers.org/lxcfs";
    changelog = "https://linuxcontainers.org/lxcfs/news/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 fpletz ];
  };
}
