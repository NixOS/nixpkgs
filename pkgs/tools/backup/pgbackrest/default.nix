{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, postgresql
, openssl
, lz4
, bzip2
, libxml2
, zlib
, zstd
, libyaml
}:
stdenv.mkDerivation rec {
  pname = "pgbackrest";
  version = "2.42";

  src = fetchFromGitHub {
    owner = "pgbackrest";
    repo = "pgbackrest";
    rev = "release/${version}";
    sha256 = "sha256-uI2/2zxCDgzapiGbZe+Y1lsZAMjScomvxFw4Lj/R1A0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ postgresql openssl lz4 bzip2 libxml2 zlib zstd libyaml ];

  postUnpack = ''
    sourceRoot+=/src
  '';

  meta = with lib; {
    description = "Reliable PostgreSQL backup & restore";
    homepage = "https://pgbackrest.org/";
    changelog = "https://github.com/pgbackrest/pgbackrest/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ zaninime ];
  };
}
