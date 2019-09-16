{ stdenv
, pythonPackages
, glibcLocales
, devpi-server
, git
, mercurial
} :

pythonPackages.buildPythonApplication rec {
  pname = "devpi-client";
  version = "4.1.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0f5jkvxx9fl8v5vwbwmplqhjsdfgiib7j3zvn0zxd8krvi2s38fq";
  };

  checkInputs = with pythonPackages; [
                    pytest pytest-flakes webtest mock
                    devpi-server tox
                    sphinx wheel git mercurial detox
                    setuptools
                    ];
  checkPhase = ''
    export PATH=$PATH:$out/bin
    export HOME=$TMPDIR # fix tests failing in sandbox due to "/homeless-shelter"

    # setuptools do not get propagated into the tox call (cannot import setuptools)
    rm testing/test_test.py

    # test_pypi_index_attributes tries to connect to upstream pypi
    py.test -k 'not test_pypi_index_attributes' testing
  '';

  LC_ALL = "en_US.UTF-8";
  buildInputs = with pythonPackages; [ glibcLocales pkginfo check-manifest ];
  propagatedBuildInputs = with pythonPackages; [ py devpi-common pluggy setuptools ];

  meta = with stdenv.lib; {
    homepage = http://doc.devpi.net;
    description = "Client for devpi, a pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };

}
