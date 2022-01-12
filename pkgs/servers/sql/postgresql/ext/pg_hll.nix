{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_hll";
  version = "2.16";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "postgresql-hll";
    rev    = "refs/tags/v${version}";
    sha256 = "0icns4m3dkm20fs6gznciwsb8ba8gcc316igz6j7qwjdnyg2ppbf";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "HyperLogLog for PostgreSQL";
    homepage    = "https://github.com/citusdata/postgresql-hll";
    changelog   = "https://github.com/citusdata/postgresql-hll/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.asl20;
  };
}
