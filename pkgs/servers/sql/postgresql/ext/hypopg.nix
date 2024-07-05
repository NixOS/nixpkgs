{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "hypopg";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "HypoPG";
    repo = "hypopg";
    rev = version;
    hash = "sha256-YzQnkQi9BlDryUySnWHWeTanhgfVUXjHjOqj+nQucCY=";
  };

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib *${postgresql.dlSuffix}
    install -D -t $out/share/postgresql/extension *.control
    install -D -t $out/share/postgresql/extension *.sql
  '';

  meta = with lib; {
    description = "Hypothetical Indexes for PostgreSQL";
    homepage = "https://hypopg.readthedocs.io";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ bbigras ];
  };
}
