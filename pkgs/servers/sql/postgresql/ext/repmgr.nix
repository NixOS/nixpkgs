{ stdenv, fetchFromGitHub
, postgresql
, openssl
, zlib
, readline
, flex
}:

stdenv.mkDerivation rec {
  pname = "repmgr";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "2ndQuadrant";
    repo = "repmgr";
    rev = "v${version}";
    hash = "sha256-1CshcutjgwWCRxBfjlNGDLKMT5BYqb+sh4i+/E/YN38=";
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

  meta = with stdenv.lib; {
    homepage = "https://repmgr.org/";
    description = "Replication manager for PostgreSQL cluster";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ zimbatm ];
  };
}
