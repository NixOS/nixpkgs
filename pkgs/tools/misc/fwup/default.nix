{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, DiskArbitration
, pkg-config
, bzip2
, libarchive
, libconfuse
, libsodium
, xz
, zlib
, coreutils
, dosfstools
, mtools
, unzip
, zip
, which
, xdelta
}:

stdenv.mkDerivation rec {
  pname = "fwup";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    rev = "v${version}";
    sha256 = "sha256-ayfcnIZ7MuBsCy1giwmY2D2C6AukwS+fevmXqGa4c1w=";
  };

  patches = [ ./fix-testrunner-darwin.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    bzip2
    libarchive
    libconfuse
    libsodium
    xz
    zlib
  ]
    ++ lib.optionals stdenv.isDarwin [
    DiskArbitration
  ];

  propagatedBuildInputs = [
    coreutils
    dosfstools
    mtools
    unzip
    zip
  ];

  checkInputs = [
    which
    xdelta
  ];

  doCheck = true;

  meta = with lib; {
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = "https://github.com/fhunleth/fwup";
    license = licenses.asl20;
    maintainers = [ maintainers.georgewhewell ];
    platforms = platforms.all;
  };
}
