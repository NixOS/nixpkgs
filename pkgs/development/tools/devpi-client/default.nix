{ stdenv
, pythonPackages
, glibcLocales
, devpi-server
} :

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "devpi-client";
  version = "3.1.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0w47x3lkafcg9ijlaxllmq4886nsc91w49ck1cd7vn2gafkwjkgr";
  };

  doCheck = true;
  checkInputs = with pythonPackages; [ pytest webtest mock devpi-server ];
  checkPhase = "py.test";

  LC_ALL = "en_US.UTF-8";
  buildInputs = with pythonPackages; [ glibcLocales pkginfo tox check-manifest ];
  propagatedBuildInputs = with pythonPackages; [ py devpi-common pluggy ];

  meta = {
    homepage = http://doc.devpi.net;
    description = "Github-style pypi index server and packaging meta tool";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ lewo makefu ];

  };
}
