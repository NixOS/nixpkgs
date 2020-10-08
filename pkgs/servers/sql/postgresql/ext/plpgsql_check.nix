{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "plpgsql_check";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = "v${version}";
    sha256 = "19vcvfhxh0922qgibahmkyf7czniycqbzccxdw65j1ia7fd8yyc3";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with stdenv.lib; {
    description = "Linter tool for language PL/pgSQL";
    homepage = "https://github.com/okbob/plpgsql_check";
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
