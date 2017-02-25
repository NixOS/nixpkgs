{ stdenv, lib, fetchFromGitHub, gcc, postgresql }:

stdenv.mkDerivation {

  name = "pg_similarity-1.0";
  src = fetchFromGitHub {
    owner = "eulerto";
    repo = "pg_similarity";
    rev = "be1a8b08c8716e59b89982557da9ea68cdf868c5";
    sha256 = "1z4v4r2yccdr8kz3935fnk1bc5vj0qj0apscldyap4wxlyi89xim";
  };

  buildInputs = [ postgresql gcc ];
  buildPhase = "USE_PGXS=1 make";
  installPhase = ''
    mkdir -p $out/bin   # for buildEnv to setup proper symlinks
    install -D pg_similarity.so -t $out/lib/
    install -D ./{pg_similarity--unpackaged--1.0.sql,pg_similarity--1.0.sql,pg_similarity.control} -t $out/share/extension
  '';

  meta = {
    description = ''
       pg_similarity is an extension to support similarity queries on PostgreSQL. The implementation
       is tightly integrated in the RDBMS in the sense that it defines operators so instead of the traditional
       operators (= and <>) you can use ~~~ and ~!~ (any of these operators represents a similarity function).
    '';
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ danbst ];
  };
}
