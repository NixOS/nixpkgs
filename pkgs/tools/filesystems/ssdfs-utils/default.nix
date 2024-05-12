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
  version = "4.40";

  src = fetchFromGitHub {
    owner = "dubeyko";
    repo = "ssdfs-tools";
    rev = "5f121f793e344cbbe98764b0a5758511da8c3d23";
    hash = "sha256-VSHs8BBp+n7jbr9KtTXykpUZbTfc999eYA5wtFsmMdY=";
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
