{ lib, stdenv, fetchurl, kernel, perl, kmod, elfutils }:
let
  version = "1.63";
in
stdenv.mkDerivation {
  name = "ndiswrapper-${version}-${kernel.version}";
  inherit version;

  hardeningDisable = [ "pic" ];

  patches = [ ./no-sbin.patch ];

  # need at least .config and include
  kernel = kernel.dev;

  buildPhase = "
    echo make KBUILD=$(echo \$kernel/lib/modules/*/build);
    echo -n $kernel/lib/modules/*/build > kbuild_path
    export PATH=${kmod}/sbin:$PATH
    make KBUILD=$(echo \$kernel/lib/modules/*/build);
  ";

  installPhase = ''
    make install KBUILD=$(cat kbuild_path) DESTDIR=$out
    mv $out/usr/sbin/* $out/sbin/
    mv $out/usr/share $out/
    rm -r $out/usr

    patchShebangs $out/sbin
  '';

  src = fetchurl {
    url = "mirror://sourceforge/ndiswrapper/files/stable/ndiswrapper-${version}.tar.gz";
    sha256 = "1v6b66jhisl110jfl00hm43lmnrav32vs39d85gcbxrjqnmcx08g";
  };

  buildInputs = [ perl elfutils ];

  meta = {
    description = "Ndis driver wrapper for the Linux kernel";
    homepage = "https://sourceforge.net/projects/ndiswrapper";
    license = "GPL";
    platforms = [ "i686-linux" "x86_64-linux" ];
    broken = lib.versionAtLeast kernel.version "5.8";
  };
}
