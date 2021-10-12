{ lib, stdenv, fetchFromGitHub, cmake, zlib, openssl, protobuf, protobufc, lzo, libunwind }:
stdenv.mkDerivation rec {
  pname = "zbackup";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "zbackup";
    repo = "zbackup";
    rev = version;
    hash = "sha256-9Fk4EhEeQ2J4Kirc7oad4CzmW70Mmza6uozd87qfgZI=";
  };

  buildInputs = [ zlib openssl protobuf lzo libunwind ];
  nativeBuildInputs = [ cmake protobufc ];

  meta = {
    description = "A versatile deduplicating backup tool";
    homepage = "http://zbackup.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
