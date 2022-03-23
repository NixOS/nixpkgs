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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    rev = "v${version}";
    sha256 = "sha256-ARwBm9p6o/iC09F6pc5c4qq3WClNTyAvLPsG58YQOAM=";
  };

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
  ] ++ lib.optionals stdenv.isDarwin [
    DiskArbitration
  ];

  propagatedBuildInputs = [
    coreutils
    unzip
    zip
  ] ++ lib.optionals doCheck [
    mtools
    dosfstools
  ];

  checkInputs = [
    which
    xdelta
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = "https://github.com/fhunleth/fwup";
    license = licenses.asl20;
    maintainers = [ maintainers.georgewhewell ];
    platforms = platforms.all;
  };
}
