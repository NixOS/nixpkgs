{ stdenv, lib, fetchurl, autoreconfHook, xz, zlib, pkgconfig, libxslt }:

let
  systems = [ "current-system" "booted-system" ];
  modulesDirs = lib.concatMapStringsSep ":" (x: "/run/${x}/kernel-modules/lib/modules") systems;

in stdenv.mkDerivation rec {
  name = "kmod-${version}";
  version = "22";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/kmod/${name}.tar.xz";
    sha256 = "10lzfkmnpq6a43a3gkx7x633njh216w0bjwz31rv8a1jlgg1sfxs";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libxslt ];
  buildInputs = [ xz /* zlib */ ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-xz"
    "--with-modulesdirs=${modulesDirs}"
    # "--with-zlib"
  ];

  patches = [ ./module-dir.patch ];

  postInstall = ''
    for prog in rmmod insmod lsmod modinfo modprobe depmod; do
      ln -sv $out/bin/kmod $out/bin/$prog
    done

    # Backwards compatibility
    ln -s bin $out/sbin
  '';

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/kmod/;
    description = "Tools for loading and managing Linux kernel modules";
    platforms = stdenv.lib.platforms.linux;
  };
}
