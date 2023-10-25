{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, gnutls
, libgcrypt
, libpar2
, libsigcxx
, libxml2
, ncurses
, openssl
, zlib
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "nzbget";
  version = "21.1";

  src = fetchurl {
    url = "https://github.com/nzbget/nzbget/releases/download/v${version}/nzbget-${version}-src.tar.gz";
    hash = "sha256-To/BvrgNwq8tajajOjP0Te3d1EhgAsZE9MR5MEMHICU=";
  };

  patches = [
    # openssl 3 compatibility
    # https://github.com/nzbget/nzbget/pull/793
    (fetchpatch {
      name = "daemon-connect-dont-use-fips-mode-set-with-openssl-3.patch";
      url = "https://github.com/nzbget/nzbget/commit/f76e8555504e3af4cf8dd4a8c8e374b3ca025099.patch";
      hash = "sha256-39lvnhBK4126TYsRbJOUxsV9s9Hjuviw7CH/wWn/VkM=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gnutls
    libgcrypt
    libpar2
    libsigcxx
    libxml2
    ncurses
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) nzbget; };

  meta = with lib; {
    homepage = "https://nzbget.net";
    license = licenses.gpl2Plus;
    description = "A command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
