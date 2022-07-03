{ lib, stdenv, fetchurl, makeWrapper
, pkg-config, openssl, fuse, libxml2
, cabextract ? null
, cdrkit ? null
, mtools ? null
, ntfs3g ? null
, syslinux ? null
}:

stdenv.mkDerivation rec {
  version = "1.13.5";
  pname = "wimlib";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl fuse libxml2 ntfs3g ];

  src = fetchurl {
    url = "https://wimlib.net/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-MvzJ6bFEt8sdtMhuEEyngoPNwiXhP+grJzZgWGrv4yM=";
  };

  preBuild = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace programs/mkwinpeimg.in \
      --replace '/usr/lib/syslinux' "${syslinux}/share/syslinux"
  '';

  postInstall = let
    path = lib.makeBinPath  ([ cabextract mtools ntfs3g ] ++ lib.optionals (!stdenv.isDarwin) [ cdrkit syslinux ]);
  in ''
    for prog in $out/bin/*; do
      wrapProgram $prog --prefix PATH : ${path}
    done
  '';

  doCheck = (!stdenv.isDarwin);

  preCheck = ''
    patchShebangs tests
  '';

  meta = with lib; {
    homepage = "https://wimlib.net";
    description = "A library and program to extract, create, and modify WIM files";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    license = with licenses; [ gpl3 lgpl3 cc0 ];
  };
}
