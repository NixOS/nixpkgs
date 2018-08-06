{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "pg_jobmon-${version}";
  version = "1.3.3";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "omniti-labs";
    repo   = "pg_jobmon";
    rev    = "refs/tags/v${version}";
    sha256 = "09izh6j1rpkllmy2kjhd9pwzld6lryp7825129k5jbbvnavxv6g8";
  };

  installPhase = ''
    mkdir -p $out/share/extension

    cp -v updates/*.sql $out/share/extension
    cp -v sql/*.sql     $out/share/extension
    cp -v *.control     $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "Log and monitor PostgreSQL jobs";
    homepage    = https://github.com/omniti-labs/pg_jobmon;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.postgresql;
  };
}
