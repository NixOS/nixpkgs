{ lib, stdenv, fetchFromGitHub, fetchpatch
, cmake, protobufc
, libunwind, lzo, openssl, protobuf, zlib
}:

stdenv.mkDerivation rec {
  pname = "zbackup";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "zbackup";
    repo = "zbackup";
    rev = version;
    hash = "sha256-9Fk4EhEeQ2J4Kirc7oad4CzmW70Mmza6uozd87qfgZI=";
  };

  patches = [
    # compare with https://github.com/zbackup/zbackup/pull/158;
    # but that doesn't apply cleanly to this version
    ./protobuf-api-change.patch
  ];

  buildInputs = [ zlib openssl protobuf lzo libunwind ];
  nativeBuildInputs = [ cmake protobufc ];

  meta = {
    description = "A versatile deduplicating backup tool";
    homepage = "http://zbackup.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
