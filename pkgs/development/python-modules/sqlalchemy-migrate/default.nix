{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, python
, unittest2, scripttest, pytz, pylint, mock
, testtools, pbr, tempita, decorator, sqlalchemy
, six, sqlparse, testrepository
}:
buildPythonPackage rec {
  pname = "sqlalchemy-migrate";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bngmbcry97kwhrxwm0d74zg9qg7gmiws6rd78xshyfgpcqdmylc";
  };

  # See: https://review.openstack.org/#/c/608382/
  patches = [ (fetchpatch {
    url = https://github.com/openstack/sqlalchemy-migrate/pull/18.patch;
    sha256 = "1qyfq2m7w7xqf0r9bc2x42qcra4r9k9l9g1jy5j0fvlb6bvvjj07";
  }) ];

  checkInputs = [ unittest2 scripttest pytz mock testtools testrepository ];
  propagatedBuildInputs = [ pbr tempita decorator sqlalchemy six sqlparse ];

  doCheck = !stdenv.isDarwin;

  prePatch = ''
    sed -i -e /tempest-lib/d \
           -e /testtools/d \
      test-requirements.txt
  '';
  checkPhase = ''
    export PATH=$PATH:$out/bin
    echo sqlite:///__tmp__ > test_db.cfg
    # depends on ibm_db_sa
    rm migrate/tests/changeset/databases/test_ibmdb2.py
    # wants very old testtools
    rm migrate/tests/versioning/test_schema.py
    # transient failures on py27
    substituteInPlace migrate/tests/versioning/test_util.py --replace "test_load_model" "noop"
    ${python.interpreter} setup.py test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/openstack/sqlalchemy-migrate;
    description = "Schema migration tools for SQLAlchemy";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };
}
