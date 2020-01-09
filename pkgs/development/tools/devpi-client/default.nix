{ stdenv
, buildPythonApplication
, fetchPypi
# buildInputs
, glibcLocales
, pkginfo
, check-manifest
# propagatedBuildInputs
, py
, devpi-common
, pluggy
, setuptools
# CheckInputs
, pytest
, pytest-flake8
, webtest
, mock
, devpi-server
, tox
, sphinx
, wheel
, git
, mercurial
} :

buildPythonApplication rec {
  pname = "devpi-client";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hyj3xc5c6658slk5wgcr9rh7hwi5r3hzxk1p6by61sqx5r38v3q";
  };

  buildInputs = [ glibcLocales pkginfo check-manifest ];

  propagatedBuildInputs = [ py devpi-common pluggy setuptools ];

  checkInputs = [
    pytest pytest-flake8 webtest mock
    devpi-server tox
    sphinx wheel git mercurial
  ];

  checkPhase = ''
    export PATH=$PATH:$out/bin
    export HOME=$TMPDIR # fix tests failing in sandbox due to "/homeless-shelter"

    # test_pypi_index_attributes: tries to connect to upstream pypi
    # test_test: setuptools does not get propagated into the tox call (cannot import setuptools), also no detox
    # test_index: hangs forever
    # test_upload: fails multiple times with
    # > assert args[0], args
    # F AssertionError: [None, local('/build/pytest-of-nixbld/pytest-0/test_export_attributes_git_set0/repo2/setupdir/setup.py'), '--name']

    py.test -k 'not test_pypi_index_attributes \
                and not test_test \
                and not test_index \
                and not test_upload' testing
  '';

  LC_ALL = "en_US.UTF-8";

  meta = with stdenv.lib; {
    homepage = http://doc.devpi.net;
    description = "Client for devpi, a pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };

}
