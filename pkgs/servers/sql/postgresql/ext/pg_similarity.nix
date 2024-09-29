{ stdenv, lib, fetchFromGitHub, gcc, postgresql, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "pg_similarity";
  version = "1.0-unstable-2021-01-12";

  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "pg_similarity";
    rev = "b9cb0a2d501b91e33cd1ef550b05483ca3563f71";
    sha256 = "sha256-L04ANvyfzHgW7fINeJEY6T77Vojq3SI8P1TWiCRSPs0=";
  };

  buildInputs = [ postgresql gcc ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    install -D pg_similarity${postgresql.dlSuffix} -t $out/lib/
    install -D ./{pg_similarity--unpackaged--1.0.sql,pg_similarity--1.0.sql,pg_similarity.control} -t $out/share/postgresql/extension
  '';

  passthru.updateScript = unstableGitUpdater {};

  meta = {
    description = "Extension to support similarity queries on PostgreSQL";
    longDescription = ''
       pg_similarity is an extension to support similarity queries on PostgreSQL. The implementation
       is tightly integrated in the RDBMS in the sense that it defines operators so instead of the traditional
       operators (= and <>) you can use ~~~ and ~!~ (any of these operators represents a similarity function).
    '';
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ danbst ];
  };
}
