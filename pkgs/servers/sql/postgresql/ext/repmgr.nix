{ lib, stdenv, fetchFromGitHub
, postgresql
, openssl
, zlib
, readline
, flex
}:

stdenv.mkDerivation rec {
  pname = "repmgr";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "2ndQuadrant";
    repo = "repmgr";
    rev = "v${version}";
    sha256 = "sha256-hIhVjSSJAgH/eXiuz0xlTFgp9q+Y41ICeCrRFGss3mk=";
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
