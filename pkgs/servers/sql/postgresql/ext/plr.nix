{ lib, stdenv, fetchFromGitHub, pkg-config, R, postgresql }:

stdenv.mkDerivation rec {
  pname = "plr";
  version = "8.4.5";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    rev = "REL${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-G/V3I1JI6dWto/hK6lfOTBYEvbmkovvnvk2TwSQq4no=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ R postgresql ];
  preBuild = ''
    export USE_PGXS=1
  '';
  installPhase = ''
    install -D plr.so -t $out/lib/
    install -D {plr--*.sql,plr.control} -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "PL/R - R Procedural Language for PostgreSQL";
    homepage = "https://github.com/postgres-plr/plr";
    maintainers = with maintainers; [ qoelet ];
    platforms = postgresql.meta.platforms;
    license = licenses.gpl2Only;
  };
}
