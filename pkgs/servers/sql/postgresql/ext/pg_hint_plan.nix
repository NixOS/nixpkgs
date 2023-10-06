{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_hint_plan";
  version = "14-1.4.0";

  src = fetchFromGitHub {
    owner = "ossc-db";
    repo = pname;
    rev = "REL${builtins.replaceStrings ["-" "."] ["_" "_"] version}";
    sha256 = "sha256-2hYDn/69264x2lMRVIp/I5chjocL6UqIw5ry1qdRcDM=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Extension to tweak PostgreSQL execution plans using so-called 'hints' in SQL comments";
    homepage = "https://github.com/ossc-db/pg_hint_plan";
    maintainers = with maintainers; [ _1000101 ];
    platforms = postgresql.meta.platforms;
    license = licenses.bsd3;
    broken = versionOlder postgresql.version "14";
  };
}
