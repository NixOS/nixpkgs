{ lib, stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  pname = "temporal_tables";
  version = "unstable-2021-02-20";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "arkhipov";
    repo   = pname;
    rev    = "3ce22da51f2549e8f8b8fbf2850c63eb3a2f1fbb";
    sha256 = "sha256-kmcl6vVHRZj2G5GijEyaZgDpZBDcdIUKzXv0rYYqUu4=";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/postgresql/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "Temporal Tables PostgreSQL Extension ";
    homepage    = "https://github.com/mlt/temporal_tables";
    maintainers = with maintainers; [ ggpeti ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.bsd2;
  };
}
