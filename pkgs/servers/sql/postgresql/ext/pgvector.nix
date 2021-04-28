{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pgvector";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ankane";
    repo = pname;
    rev = "v${version}";
    sha256 = "03i8rq9wp9j2zdba82q31lzbrqpnhrqc8867pxxy3z505fxsvfzb";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib vector.so
    install -D -t $out/share/postgresql/extension vector-*.sql
    install -D -t $out/share/postgresql/extension vector.control
  '';

  meta = with lib; {
    description = "Open-source vector similarity search for PostgreSQL";
    homepage = "https://github.com/ankane/pgvector";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
