{ stdenv, lib, fetchurl, autoreconfHook, xz, zlib, pkgconfig, libxslt }:

let
  systems = [ "/run/current-system/kernel-modules" "/run/booted-system/kernel-modules" "" ];
  modulesDirs = lib.concatMapStringsSep ":" (x: "${x}/lib/modules") systems;

in stdenv.mkDerivation rec {
  name = "kmod-${version}";
  version = "24";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/kmod/${name}.tar.xz";
    sha256 = "15xkkkzvca9flvkm48gkh8y8f13vlm3sl7nz9ydc7b3jy4fqs2v1";
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
