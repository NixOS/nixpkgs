{ stdenv, lib, fetchurl, autoreconfHook, pkgconfig
, libxslt, xz, elf-header
, withStatic ? false }:

let
  systems = [ "/run/current-system/kernel-modules" "/run/booted-system/kernel-modules" "" ];
  modulesDirs = lib.concatMapStringsSep ":" (x: "${x}/lib/modules") systems;

in stdenv.mkDerivation rec {
  pname = "kmod";
  version = "27";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kernel/${pname}/${pname}-${version}.tar.xz";
    sha256 = "035wzfzjx4nwidk747p8n085mgkvy531ppn16krrajx2dkqzply1";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libxslt ];
  buildInputs = [ xz ] ++ lib.optional stdenv.isDarwin elf-header;

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-xz"
    "--with-modulesdirs=${modulesDirs}"
  ] ++ lib.optional withStatic "--enable-static";

  patches = [ ./module-dir.patch ]
    ++ lib.optional stdenv.isDarwin ./darwin.patch
    ++ lib.optional withStatic ./enable-static.patch;

  postInstall = ''
    for prog in rmmod insmod lsmod modinfo modprobe depmod; do
      ln -sv $out/bin/kmod $out/bin/$prog
    done

    # Backwards compatibility
    ln -s bin $out/sbin
  '';

  meta = with stdenv.lib; {
    description = "Tools for loading and managing Linux kernel modules";
    longDescription = ''
      kmod is a set of tools to handle common tasks with Linux kernel modules
      like insert, remove, list, check properties, resolve dependencies and
      aliases. These tools are designed on top of libkmod, a library that is
      shipped with kmod.
    '';
    homepage = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/";
    downloadPage = "https://www.kernel.org/pub/linux/utils/kernel/kmod/";
    changelog = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/plain/NEWS?h=v${version}";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
