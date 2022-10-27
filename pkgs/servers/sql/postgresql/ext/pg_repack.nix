{ lib, stdenv, fetchFromGitHub, postgresql, openssl, zlib, readline }:

stdenv.mkDerivation rec {
  pname = "pg_repack";
  version = "1.4.8";

  buildInputs = [ postgresql openssl zlib readline ];

  src = fetchFromGitHub {
    owner  = "reorg";
    repo   = "pg_repack";
    rev    = "f42c1bd707bd5d69a9eb33494133db2e47a2c05a"; # no release tag
    sha256 = "sha256-pZjspnmPTXS/SbyLAd7vcoF01cbC6PnxZjuto4lUuQA=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ danbst ];
    inherit (postgresql.meta) platforms;
    inherit (src.meta) homepage;
  };
}
