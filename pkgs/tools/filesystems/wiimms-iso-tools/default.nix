{lib, stdenv, fetchurl, zlib, ncurses, fuse}:

stdenv.mkDerivation rec {
  name = "wiimms-iso-tools";
  version = "3.02a";

  src = fetchurl {
    url = "https://download.wiimm.de/source/wiimms-iso-tools/wiimms-iso-tools.source-${version}.tar.bz2";
    sha256 = "074cvcaqz23xyihslc6n64wwxwcnl6xp7l0750yb9pc0wrqxmj69";
  };

  buildInputs = [ zlib ncurses fuse ];

  patches = [ ./fix-paths.diff ];
  postPatch = ''
    patchShebangs setup.sh
    patchShebangs gen-template.sh
    patchShebangs gen-text-file.sh
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";
  INSTALL_PATH = "$out";

  installPhase = ''
    mkdir "$out"
    patchShebangs install.sh
    ./install.sh --no-sudo
  '';

  meta = with lib; {
    homepage = "https://wit.wiimm.de";
    description = "A set of command line tools to manipulate Wii and GameCube ISO images and WBFS containers";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nilp0inter ];
  };
}
