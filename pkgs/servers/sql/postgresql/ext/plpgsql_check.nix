{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "plpgsql_check";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rjbzcdvwx19ql0ilccr47inilf7kh5hn7aacjqs1nxk91g3x7yf";
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
