{ stdenv, pythonPackages, glibcLocales} :

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "devpi-client";
  version = "3.1.0rc1";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0kfyva886k9zxmilqb2yviwqzyvs3n36if3s56y4clbvw9hr2lc3";
  };
  # requires devpi-server which is currently not packaged
  doCheck = true;
  checkInputs = with pythonPackages; [ pytest webtest mock ];
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
