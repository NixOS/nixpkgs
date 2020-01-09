{ stdenv, fetchFromGitHub, postgresql, openssl, zlib, readline }:

stdenv.mkDerivation rec {
  pname = "repmgr";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "2ndQuadrant";
    repo = "repmgr";
    rev = "v${version}";
    sha256 = "185789f7igvlqyqcb8kf42jjq8g0wbs2aqd9kimrq5kf4srwgpim";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  buildInputs = [ postgresql openssl zlib readline ];

  meta = with stdenv.lib; {
    homepage = "https://repmgr.org/";
    description = "Replication manager for PostgreSQL cluster";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ zimbatm ];
  };
}
