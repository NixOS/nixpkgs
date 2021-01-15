{ lib, stdenv, fetchFromGitHub, gtk3, pkgconfig, intltool, libxslt, makeWrapper,
  coreutils, zip, unzip, p7zip, unrar, gnutar, bzip2, gzip, lhasa, wrapGAppsHook }:

stdenv.mkDerivation rec {
  version = "0.5.4.14";
  pname = "xarchiver";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = version;
    sha256 = "1iklwgykgymrwcc5p1cdbh91v0ih1m58s3w9ndl5kyd44bwlb7px";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper wrapGAppsHook ];
  buildInputs = [ gtk3 intltool libxslt ];

  postFixup = ''
    wrapProgram $out/bin/xarchiver \
    --prefix PATH : ${lib.makeBinPath [ zip unzip p7zip unrar gnutar bzip2 gzip lhasa coreutils ]}
  '';

  meta = {
    description = "GTK frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = "https://github.com/ib/xarchiver";
    maintainers = [ lib.maintainers.domenkozar ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
}
