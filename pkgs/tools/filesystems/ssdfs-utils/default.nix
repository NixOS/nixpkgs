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
  version = "4.45";

  src = fetchFromGitHub {
    owner = "dubeyko";
    repo = "ssdfs-tools";
    rev = "f78ebf2a19eb338ae6858aa4f28133b117507df7";
    hash = "sha256-RKVcXZakYDd7Vfd1w0pNs9/oMRzvzRr8VabpUBRcKc8=";
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
