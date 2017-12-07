{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "mkinitcpio-nfs-utils-0.3";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/mkinitcpio/${name}.tar.xz";
    sha256 = "0fc93sfk41ycpa33083kyd7i4y00ykpbhj5qlw611bjghj4x946j";
    # ugh, upstream...
    name = "${name}.tar.gz";
  };

  makeFlags = [ "DESTDIR=$(out)" "bindir=/bin" ];

  postInstall = ''
    rm -rf $out/usr
  '';

  meta = with stdenv.lib; {
    homepage = https://archlinux.org/;
    description = "ipconfig and nfsmount tools for root on NFS, ported from klibc";
    license = licenses.gpl2;
    platforms  = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
