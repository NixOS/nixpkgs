{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "pg_cron-${version}";
  version = "1.0.2";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "pg_cron";
    rev    = "refs/tags/v${version}";
    sha256 = "0z743bbal9j0pvqskznfj0zvjsqvdl7p90d4fdrl0sc0crc3nvyx";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/extension}

    cp *.so      $out/lib
    cp *.sql     $out/share/extension
    cp *.control $out/share/extension
  '';

  passthru = {
    versionCheck = builtins.compareVersions postgresql.version "9.5" >= 0;
  };

  meta = with stdenv.lib; {
    description = "Run Cron jobs through PostgreSQL";
    homepage    = https://www.citusdata.com/;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.postgresql;
  };
}
