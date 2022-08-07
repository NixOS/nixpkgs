{ lib, stdenv, fetchFromGitHub
, postgresql
, openssl
, zlib
, readline
, flex
}:

stdenv.mkDerivation rec {
  pname = "repmgr";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "2ndQuadrant";
    repo = "repmgr";
    rev = "v${version}";
    sha256 = "sha256-M8FMin9y6nAiPYeT5pUUy0KyZ1dkuH708GshZ6GoXXw=";
  };

  nativeBuildInputs = [ flex ];

  buildInputs = [ postgresql openssl zlib readline ];

  installPhase = ''
    mkdir -p $out/{bin,lib,share/postgresql/extension}

    cp repmgr{,d} $out/bin
    cp *.so       $out/lib
    cp *.sql      $out/share/postgresql/extension
    cp *.control  $out/share/postgresql/extension
  '';

  meta = with lib; {
    homepage = "https://repmgr.org/";
    description = "Replication manager for PostgreSQL cluster";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ zimbatm ];
  };
}
