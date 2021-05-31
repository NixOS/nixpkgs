{ stdenv, fetchFromGitHub, fetchpatch, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_partman";
  version = "4.4.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "pgpartman";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0wr2nivp0b8vk355rnv4bygiashq98q9zhfgdbxzhm7bgxd01rk2";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-33204.patch";
      url = "https://github.com/pgpartman/pg_partman/commit/0b6565ad378c358f8a6cd1d48ddc482eb7f854d3.patch";
      includes = [
        "sql/functions/check_name_length.sql"
        "sql/tables/tables.sql"
      ];
      sha256 = "002zbbabianagqpck4kdnj0db1pq5v69v08q7kd5vnks2qy31c8f";
    })
  ];

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp src/*.so      $out/lib
    cp updates/*     $out/share/postgresql/extension
    cp -r sql/*      $out/share/postgresql/extension
    cp *.control     $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "Partition management extension for PostgreSQL";
    homepage    = "https://github.com/pgpartman/pg_partman";
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
