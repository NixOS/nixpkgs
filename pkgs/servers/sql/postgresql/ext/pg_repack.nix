{ lib, stdenv, fetchFromGitHub, postgresql, openssl, zlib, readline }:

stdenv.mkDerivation rec {
  pname = "pg_repack";
  version = "1.4.8";

  buildInputs = [ postgresql openssl zlib readline ];

  src = fetchFromGitHub {
    owner  = "reorg";
    repo   = "pg_repack";
    rev    = "ver_${version}";
    sha256 = "sha256-Et8aMRzG7ez0uy9wG6qsg57/kPPZdUhb+/gFxW86D08=";
  };

  installPhase = ''
    install -D bin/pg_repack -t $out/bin/
    install -D lib/pg_repack.so -t $out/lib/
    install -D lib/{pg_repack--${version}.sql,pg_repack.control} -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Reorganize tables in PostgreSQL databases with minimal locks";
    longDescription = ''
      pg_repack is a PostgreSQL extension which lets you remove bloat from tables and indexes, and optionally restore
      the physical order of clustered indexes. Unlike CLUSTER and VACUUM FULL it works online, without holding an
      exclusive lock on the processed tables during processing. pg_repack is efficient to boot,
      with performance comparable to using CLUSTER directly.
    '';
    homepage = "https://github.com/reorg/pg_repack";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danbst ];
    inherit (postgresql.meta) platforms;
  };
}
