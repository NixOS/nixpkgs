{ lib, stdenv, fetchFromGitHub, postgresql, protobufc }:

stdenv.mkDerivation rec {
  pname = "cstore_fdw";
  version = "1.7.0";

  nativeBuildInputs = [ protobufc ];
  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "cstore_fdw";
    rev    = "refs/tags/v${version}";
    sha256 = "129mpq8rq16jg7idh6c1j6nij64iywrs7wl3cn02bdb3h8f19z1b";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    broken      = true;
    description = "Columnar storage for PostgreSQL";
    homepage    = "https://www.citusdata.com/";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.asl20;
  };
}
