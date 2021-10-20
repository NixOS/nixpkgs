{ lib, stdenv, fetchFromGitHub, pkg-config, R, postgresql }:

stdenv.mkDerivation rec {
  pname = "plr";
  version = "8.4.4";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    rev = "REL${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "15dygf8klx2a4kzpmc1qnch629gcaa43ba1p3cqk9r1db4ima24k";
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
