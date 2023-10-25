{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, python
, scripttest
, pytz
, pbr
, tempita
, decorator
, sqlalchemy
, six
, sqlparse
, testrepository
}:

buildPythonPackage rec {
  pname = "sqlalchemy-migrate";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y0lcqii7b4vp7yh9dyxrl4i77hi8jkkw7d06mgdw2h458ljxh0b";
  };

  patches = [
    # See: https://review.openstack.org/#/c/608382/
    (fetchpatch {
      url = "https://github.com/openstack/sqlalchemy-migrate/pull/18.patch";
      sha256 = "1qyfq2m7w7xqf0r9bc2x42qcra4r9k9l9g1jy5j0fvlb6bvvjj07";
    })
    ./python3.11-comp.diff
  ];

  postPatch = ''
    substituteInPlace test-requirements.txt \
      --replace "ibm_db_sa>=0.3.0;python_version<'3.0'" "" \
      --replace "ibm-db-sa-py3;python_version>='3.0'" "" \
      --replace "tempest-lib>=0.1.0" "" \
      --replace "testtools>=0.9.34,<0.9.36" "" \
      --replace "pylint" ""
  '';

  nativeCheckInputs = [ scripttest pytz testrepository ];
  propagatedBuildInputs = [ pbr tempita decorator sqlalchemy six sqlparse ];

  doCheck = !stdenv.isDarwin;

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

  meta = with lib; {
    homepage = "https://opendev.org/x/sqlalchemy-migrate";
    description = "Schema migration tools for SQLAlchemy";
    license = licenses.asl20;
    maintainers = teams.openstack.members ++ (with maintainers; [ makefu ]);
    broken = lib.versionAtLeast sqlalchemy.version "2.0.0";
  };
}
