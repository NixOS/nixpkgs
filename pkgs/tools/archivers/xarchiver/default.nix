{ lib, stdenv, fetchFromGitHub, gtk3, pkg-config, intltool, libxslt, makeWrapper,
  coreutils, zip, unzip, p7zip, unar, gnutar, bzip2, gzip, lhasa, wrapGAppsHook }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "0.5.4.21";
=======
  version = "0.5.4.20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "xarchiver";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-pYrF9fyEbay+iboL9EuoTETTI3RTcgv3yeVtAWvAe1Q=";
=======
    sha256 = "sha256-OzcfIFYaWez2B1lmAYvhm+knuYbyMu2ohs+kGEVG7K0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
