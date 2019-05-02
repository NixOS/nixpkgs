{ stdenv, buildPackages, lib, fetchurl, autoreconfHook, pkgconfig
, libxslt, xz, elf-header }:

let
  systems = [ "/run/current-system/kernel-modules" "/run/booted-system/kernel-modules" "" ];
  modulesDirs = lib.concatMapStringsSep ":" (x: "${x}/lib/modules") systems;

in stdenv.mkDerivation rec {
  pname = "kmod";
  version = "26";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/${pname}/${pname}-${version}.tar.xz";
    sha256 = "17dvrls70nr3b3x1wm8pwbqy4r8a5c20m0dhys8mjhsnpg425fsp";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libxslt ];
  buildInputs = [ xz ] ++ lib.optional stdenv.isDarwin elf-header;

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-xz"
    "--with-modulesdirs=${modulesDirs}"
  ];

  patches = [ ./module-dir.patch ]
    ++ lib.optional stdenv.isDarwin ./darwin.patch;

  postInstall = ''
    for prog in rmmod insmod lsmod modinfo modprobe depmod; do
      ln -sv $out/bin/kmod $out/bin/$prog
    done

    # Backwards compatibility
    ln -s bin $out/sbin
  '';

  meta = with stdenv.lib; {
    homepage = https://www.kernel.org/pub/linux/utils/kernel/kmod/;
    description = "Tools for loading and managing Linux kernel modules";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
