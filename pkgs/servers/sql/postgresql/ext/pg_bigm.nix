{ stdenv, fetchurl, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_bigm";
  version = "1.2";

  src = fetchurl {
    url = "mirror://osdn/pgbigm/66565/${pname}-${version}-20161011.tar.gz";
    sha256 = "1jp30za4bhwlas0yrhyjs9m03b1sj63km61xnvcbnh0sizyvhwis";
  };

  buildInputs = [ postgresql ];

  makeFlags = [ "USE_PGXS=1" ];

  installPhase = ''
    mkdir -p $out/bin    # For buildEnv to setup proper symlinks. See #22653
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with stdenv.lib; {
    description = "Text similarity measurement and index searching based on bigrams";
    homepage = "https://pgbigm.osdn.jp/";
    maintainers = [ maintainers.marsam ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
