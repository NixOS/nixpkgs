{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "pg_partman-${version}";
  version = "3.1.2";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner  = "keithf4";
    repo   = "pg_partman";
    rev    = "refs/tags/v${version}";
    sha256 = "170kv6a7dwfkgpnjafbg3wk0j6zgcp0h79q7a31drhxw0hfab4y5";
  };

  installPhase = ''
    mkdir -p $out/{lib,share/extension}

    cp -v src/*.so      $out/lib
    cp -v updates/*.sql $out/share/extension
    cp -v sql/*.sql     $out/share/extension
    cp -v *.control     $out/share/extension
  '';

  passthru = {
    versionCheck = builtins.compareVersions postgresql.version "9.4" >= 0;
  };

  meta = with stdenv.lib; {
    description = "Partition management extension for PostgreSQL";
    homepage    = https://github.com/keithf4/pg_partman;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
    license     = licenses.postgresql;
  };
}
