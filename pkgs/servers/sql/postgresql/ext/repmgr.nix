{ stdenv, fetchFromGitHub
, postgresql
, openssl
, zlib
, readline
, flex
}:

stdenv.mkDerivation rec {
  pname = "repmgr";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "2ndQuadrant";
    repo = "repmgr";
    rev = "v${version}";
    sha256 = "1igcy98ggwyx8zg4g4kz7xb32b7vc3h668r5wbfk4w49x9v97f4m";
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
