{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mkinitcpio-nfs-utils";
  version = "0.3";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/mkinitcpio/mkinitcpio-nfs-utils-${version}.tar.xz";
    sha256 = "0fc93sfk41ycpa33083kyd7i4y00ykpbhj5qlw611bjghj4x946j";
    # ugh, upstream...
    name = "mkinitcpio-nfs-utils-${version}.tar.gz";
  };

  makeFlags = [ "DESTDIR=$(out)" "bindir=/bin" ];

  postInstall = ''
    rm -rf $out/usr
  '';

  meta = with lib; {
    homepage = "https://archlinux.org/";
    description = "ipconfig and nfsmount tools for root on NFS, ported from klibc";
    license = licenses.gpl2;
    platforms  = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
