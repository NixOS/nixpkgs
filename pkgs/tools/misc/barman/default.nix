{ buildPythonApplication, fetchurl, lib
, dateutil, argcomplete, argh, psycopg2, boto3
}:

buildPythonApplication rec {
  pname = "barman";
  version = "2.11";

  outputs = [ "out" "man" ];
  src = fetchurl {
    url = "mirror://sourceforge/pgbarman/${version}/barman-${version}.tar.gz";
    sha256 = "0w5lh4aavab9ynfy2mq09ga6j4vss4k0vlc3g6f5a9i4175g9pmr";
  };

  propagatedBuildInputs = [ dateutil argh psycopg2 boto3 argcomplete ];

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
