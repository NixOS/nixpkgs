{ lib, stdenv, fetchFromGitHub, gtk3, pkg-config, intltool, libxslt, makeWrapper,
  coreutils, zip, unzip, p7zip, unar, gnutar, bzip2, gzip, lhasa, wrapGAppsHook }:

stdenv.mkDerivation rec {
  version = "0.5.4.17";
  pname = "xarchiver";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = version;
    sha256 = "00adrjpxqlaccrwjf65w3vhxfswdj0as8aj263c6f9b85llypc5v";
  };

  nativeBuildInputs = [ intltool pkg-config makeWrapper wrapGAppsHook ];
  buildInputs = [ gtk3 libxslt ];

  postFixup = ''
    wrapProgram $out/bin/xarchiver \
    --prefix PATH : ${lib.makeBinPath [ zip unzip p7zip unar gnutar bzip2 gzip lhasa coreutils ]}
  '';

  meta = {
    broken = stdenv.isDarwin;
    description = "GTK frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = "https://github.com/ib/xarchiver";
    maintainers = [ lib.maintainers.domenkozar ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
