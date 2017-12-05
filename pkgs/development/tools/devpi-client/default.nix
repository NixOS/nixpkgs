{ stdenv
, lib
, pythonPackages
, glibcLocales
, devpi-server
, git
, mercurial
} :

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "devpi-client";
  version = "3.1.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0w47x3lkafcg9ijlaxllmq4886nsc91w49ck1cd7vn2gafkwjkgr";
  };

  checkInputs = with pythonPackages; [
                    pytest webtest mock
                    devpi-server tox
                    sphinx wheel git mercurial detox
                    setuptools
                    ];
  checkPhase = ''
    export PATH=$PATH:$out/bin

    # setuptools do not get propagated into the tox call (cannot import setuptools)
    rm testing/test_test.py

    # test tries to connect to upstream pypi
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
