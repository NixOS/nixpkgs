{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "plpgsql_check";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S/b6oQPYgaM6UvloYqlwhF5rxlyKG4Vw6ejN/gK8Spg=";
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
