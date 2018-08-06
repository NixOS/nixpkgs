{ stdenv, fetchFromGitHub, postgresql, curl }:

stdenv.mkDerivation rec {
  name = "citus-${version}";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner  = "citusdata";
    repo   = "citus";
    rev    = "refs/tags/v${version}";
    sha256 = "1ipzla0whfr4zfzz4csjrzw1w9chlpgxxjlxblbsb9v9y9wd7i72";
  };

  buildInputs = [ postgresql curl ];
  makeFlags = [ "PREFIX=$(out)" ];

  patchPhase = ''
    substituteInPlace ./Makefile \
      --replace '$(DESTDIR)$(includedir_server)' "$out/include/server"
  '';

  passthru = {
    versionCheck = postgresql.compareVersion "9.6" >= 0 && postgresql.compareVersion "11" < 0;
  };

  meta = with stdenv.lib; {
    description = "Transparent, distributed sharding and replication for PostgreSQL";
    homepage    = https://www.citusdata.com/;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.asl20;
  };
}
