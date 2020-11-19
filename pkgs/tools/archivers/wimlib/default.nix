{ stdenv, fetchurl, makeWrapper
, pkgconfig, openssl, fuse, libxml2
, cabextract ? null
, cdrkit ? null
, mtools ? null
, ntfs3g ? null
, syslinux ? null
}:

stdenv.mkDerivation rec {
  version = "1.13.2";
  pname = "wimlib";

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ openssl fuse libxml2 ntfs3g ];

  src = fetchurl {
    url = "https://wimlib.net/downloads/${pname}-${version}.tar.gz";
    sha256 = "0id9ym3hzij4kpdrk0sz3ijxp5r0z1md5jch83pml9hdy1zbx5bj";
  };

  preBuild = ''
    substituteInPlace programs/mkwinpeimg.in \
      --replace '/usr/lib/syslinux' "${syslinux}/share/syslinux"
  '';

  postInstall = let
    path = stdenv.lib.makeBinPath  [ cabextract cdrkit mtools ntfs3g syslinux ];
  in ''
    for prog in $out/bin/*; do
      wrapProgram $prog --prefix PATH : ${path}
    done
  '';

  doCheck = true;

  preCheck = ''
    patchShebangs tests
  '';

  meta = with stdenv.lib; {
    homepage = "https://wimlib.net";
    description = "A library and program to extract, create, and modify WIM files";
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
    license = with licenses; [ gpl3 lgpl3 cc0 ];
  };
}
