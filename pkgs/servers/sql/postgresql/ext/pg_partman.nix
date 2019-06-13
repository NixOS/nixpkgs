{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "pg_partman";
  version = "4.1.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "pgpartman";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0bzv92x492jcwzhal9x4vc3vszixscdpxc6yq5rrqld26dhmsp06";
  };

  installPhase = ''
    mkdir -p $out/bin    # For buildEnv to setup proper symlinks. See #22653
    mkdir -p $out/{lib,share/extension}

    cp src/*.so      $out/lib
    cp updates/*     $out/share/extension
    cp -r sql/*      $out/share/extension
    cp *.control     $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "Partition management extension for PostgreSQL";
    homepage    = https://github.com/pgpartman/pg_partman;
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
