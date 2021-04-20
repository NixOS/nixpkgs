{ stdenv, curl, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgsql_http";
  version = "v1.3.1";

  buildInputs = [ curl postgresql ];

 src = fetchGit {
    url = "git://github.com/pramsey/pgsql-http";
    rev = "4a14f704d2835e4e741fcee74436fc52d8ba4e34";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Temporal Tables PostgreSQL Extension ";
    homepage    = https://github.com/pramsey/pgsql-http;
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.mit;
  };
}
