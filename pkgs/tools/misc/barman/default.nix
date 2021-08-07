{ buildPythonApplication, fetchurl, lib
, python-dateutil, argcomplete, argh, psycopg2, boto3
}:

buildPythonApplication rec {
  pname = "barman";
  version = "2.12";

  outputs = [ "out" "man" ];
  src = fetchurl {
    url = "mirror://sourceforge/pgbarman/${version}/barman-${version}.tar.gz";
    sha256 = "Ts8I6tlP2GRp90OIIKXy+cRWWvUO3Sm86zq2dtVP5YE=";
  };

  propagatedBuildInputs = [ python-dateutil argh psycopg2 boto3 argcomplete ];

  # Tests are not present in tarball
  checkPhase = ''
    $out/bin/barman --help > /dev/null
  '';

  meta = with lib; {
    homepage = "https://www.2ndquadrant.com/en/resources/barman/";
    description = "Backup and Disaster Recovery Manager for PostgreSQL";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
