{ config, lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, help2man, fuse
, util-linux, makeWrapper
, enableDebugBuild ? config.lxcfs.enableDebugBuild or false }:

with lib;
stdenv.mkDerivation rec {
  pname = "lxcfs";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxcfs";
    rev = "lxcfs-${version}";
    sha256 = "sha256-gC1Q+kG/oKfYvuHVKstpRWfL/thsemULrimPrV/eeaI=";
  };

  nativeBuildInputs = [ pkg-config help2man autoreconfHook ];
  buildInputs = [ fuse makeWrapper ];

  preConfigure = lib.optionalString enableDebugBuild ''
    sed -i 's,#AM_CFLAGS += -DDEBUG,AM_CFLAGS += -DDEBUG,' Makefile.am
  '';

  configureFlags = [
    "--with-init-script=systemd"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [ "SYSTEMD_UNIT_DIR=\${out}/lib/systemd" ];

  postInstall = ''
    # `mount` hook requires access to the `mount` command from `util-linux`:
    wrapProgram "$out/share/lxcfs/lxc.mount.hook" \
      --prefix PATH : "${util-linux}/bin"
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
