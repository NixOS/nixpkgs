{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libtool
, libuuid
, zlib
}:

stdenv.mkDerivation {
  # The files and commit messages in the repository refer to the package
  # as ssdfs-utils, not ssdfs-tools.
  pname = "ssdfs-utils";
  # The version is taken from `configure.ac`, there are no tags.
  version = "4.37";

  src = fetchFromGitHub {
    owner = "dubeyko";
    repo = "ssdfs-tools";
    rev = "f83f70409c5e4fa81e9a67f8ed7f824368aba063";
    hash = "sha256-OuGQ876HRjjSyxMbd/l8yySxmEjW1Yo1PTyO9zEt8+Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libtool
    libuuid
    zlib
  ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "SSDFS file system utilities";
    homepage = "https://github.com/dubeyko/ssdfs-tools";
    license = licenses.bsd3Clear;
    maintainers = with maintainers; [ ners ];
    platforms = platforms.linux;
  };
}
