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
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-s2TlxksxGYvRqDwRA7eLlXAyT5uPK2DiL8ma1nNVz5Q=";
=======
    sha256 = "sha256-oFGgQa52NPNOouNHvyZoen7jDIqxckpjLFfzfbbcT/c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = [
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
