{ lib, stdenv, fetchFromGitHub, pkg-config, R, postgresql }:

stdenv.mkDerivation rec {
  pname = "plr";
  version = "8.4.7";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    rev = "REL${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-PdvFEmtKfLT/xfaf6obomPR5hKC9F+wqpfi1heBphRk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ R postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D plr${postgresql.dlSuffix} -t $out/lib/
    install -D {plr--*.sql,plr.control} -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "PL/R - R Procedural Language for PostgreSQL";
    homepage = "https://github.com/postgres-plr/plr";
    changelog = "https://github.com/postgres-plr/plr/blob/${src.rev}/changelog.md";
    maintainers = with maintainers; [ qoelet ];
    platforms = postgresql.meta.platforms;
    license = licenses.gpl2Only;
  };
}
