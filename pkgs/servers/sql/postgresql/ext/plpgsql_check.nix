{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "plpgsql_check";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zl7AF+1hj6UFnf9sKO40ZTzm7edKguUYFqaT5/qf8Ic=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Linter tool for language PL/pgSQL";
    homepage = "https://github.com/okbob/plpgsql_check";
    platforms = postgresql.meta.platforms;
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
