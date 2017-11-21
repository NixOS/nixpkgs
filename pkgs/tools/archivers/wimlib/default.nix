{ stdenv, lib, fetchurl, pkgs, makeWrapper, bash
, cabextract ? null
, cdrkit ? null
, mtools ? null
, ntfs3g ? null
, syslinux ? null
}:

stdenv.mkDerivation rec {
  version = "1.12.0";
  name = "wimlib-${version}";

  nativeBuildInputs = with pkgs; [ pkgconfig makeWrapper ];
  buildInputs = with pkgs; [ openssl fuse libxml2 ntfs3g ];

  src = fetchurl {
    url = "https://wimlib.net/downloads/${name}.tar.gz";
    sha256 = "852cf59d682a91974f715f09fa98cab621b740226adcfea7a42360be0f86464f";
  };

 prefixPackages = [ cabextract cdrkit mtools ntfs3g syslinux ];

  preBuild = ''
    substituteInPlace programs/mkwinpeimg.in --replace '/usr/lib/syslinux' "${syslinux}/share/syslinux"
  '';

  postInstall = ''
    for prog in $out/bin/*; do
      wrapProgram $prog --prefix PATH : ${lib.makeBinPath prefixPackages}
    done
  '';

  doCheck = true;

  checkPhase = ''
    patchShebangs tests/
    for testfile in tests/test-*; do
      wrapProgram $testfile --prefix PATH : ${lib.makeBinPath prefixPackages}
    done
    make check
  '';

  meta = with lib; {
    homepage = https://wimlib.net;
    description = "A library and program to extract, create, and modify WIM files";
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
    license = with licenses; [ gpl3 lgpl3 cc0 ];
  };
}
