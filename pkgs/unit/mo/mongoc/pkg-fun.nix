{
  lib,
  stdenv,
  fetchzip,
  cmake,
  pkg-config,
  perl,
  openssl,
  zlib,
  cyrus_sasl,
  libbson,
  snappy,
}:
stdenv.mkDerivation rec {
  pname = "mongoc";
  version = "1.23.1";

  src = fetchzip {
    url = "https://github.com/mongodb/mongo-c-driver/releases/download/${version}/mongo-c-driver-${version}.tar.gz";
    sha256 = "1vnnk3pwbcmwva1010bl111kdcdx3yb2w7j7a78hhvrm1k9r1wp8";
  };

  # https://github.com/NixOS/nixpkgs/issues/25585
  preFixup = ''rm -rf "$(pwd)" '';

  nativeBuildInputs = [cmake pkg-config perl];
  buildInputs = [openssl zlib cyrus_sasl];
  propagatedBuildInputs = [libbson snappy];

  # -DMONGOC_TEST_USE_CRYPT_SHARED=OFF
  # The `mongodl.py` script is causing issues, and you also need to disabled sandboxing for it. However, it is used only to run some tests.
  # https://www.mongodb.com/community/forums/t/problem-downloading-crypt-shared-when-installing-the-mongodb-c-driver/189370
  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release" "-DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF" "-DMONGOC_TEST_USE_CRYPT_SHARED=OFF"];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "The official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = licenses.asl20;
    mainProgram = "mongoc-stat";
    maintainers = with maintainers; [archer-65];
    platforms = platforms.all;
  };
}
