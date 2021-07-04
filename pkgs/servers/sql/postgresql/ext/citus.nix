{ stdenv
, autoreconfHook
, postgresql
, curl
, fetchFromGitHub
, lz4
, zstd
, lib
}:

stdenv.mkDerivation rec {
  pname = "citus";
  version = "10.0.3";

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "citus";
    rev = "v${version}";
    sha256 = "hzR4tQnws5kYyLY8xzoIiOEJrCQFj0t2d+lJg2c8/AE=";
    fetchSubmodules = false;
  };

  buildInputs = [
    postgresql
    curl
    lz4
    zstd.out
  ];

  nativeBuildInputs = [
    autoreconfHook
    zstd.dev
  ];

  # dirty hack to give us a clean install tree
  installPhase = ''
    make install DESTDIR=/tmp/citus
    mkdir -p $out
    mv /tmp/citus/nix/store/*/* $out
  '';

  meta = with lib; {
    description = "Postgres Clustering";
    homepage = "https://www.citusdata.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    inherit (postgresql.meta) platforms;
  };
}
