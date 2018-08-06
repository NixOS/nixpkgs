{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "pg_partman-${version}";
  version = "3.2.1";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "keithf4";
    repo   = "pg_partman";
    rev    = "refs/tags/v${version}";
    sha256 = "069m2y20pkpk7lw7d2spaa1zpkb47dmm76rxi1d4qvq3vgfd739m";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/extension}

    cp -v src/*.so      $out/lib
    cp -v updates/*.sql $out/share/extension
    cp -v sql/*.sql     $out/share/extension
    cp -v *.control     $out/share/extension
  '';

  passthru = {
    versionCheck = postgresql.compareVersion "9.4" >= 0 && postgresql.compareVersion "11" < 0;
  };

  meta = with stdenv.lib; {
    description = "Partition management extension for PostgreSQL";
    homepage    = https://github.com/keithf4/pg_partman;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.postgresql;
  };
}
