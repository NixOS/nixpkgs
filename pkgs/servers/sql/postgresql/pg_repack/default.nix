{ stdenv, fetchFromGitHub, postgresql, openssl, zlib, readline }:

stdenv.mkDerivation rec {
    name = "pg_repack-${version}.1";
    version = "1.4.0";
    rev = "ver_${version}.1";

    buildInputs = [ postgresql openssl zlib readline ];

    src = fetchFromGitHub {
      owner = "reorg";
      repo = "pg_repack";
      inherit rev;
      sha256 = "1ym2dlhgcizyy4p5dcfw7kadrq6g34pv3liyfx604irprzhw9k74";
    };

    installPhase = ''
      install -D bin/pg_repack -t $out/bin/
      install -D lib/pg_repack.so -t $out/lib/
      install -D lib/{pg_repack--${version}.sql,pg_repack.control} -t $out/share/extension
    '';

    meta = with stdenv.lib; {
      description = "Reorganize tables in PostgreSQL databases with minimal locks";
      longDescription = ''
        pg_repack is a PostgreSQL extension which lets you remove bloat from tables and indexes, and optionally restore
        the physical order of clustered indexes. Unlike CLUSTER and VACUUM FULL it works online, without holding an
        exclusive lock on the processed tables during processing. pg_repack is efficient to boot,
        with performance comparable to using CLUSTER directly.
      '';
      license = licenses.bsd3;
      maintainers = with maintainers; [ danbst ];
      inherit (postgresql.meta) platforms;
      inherit (src.meta) homepage;
    };
}
