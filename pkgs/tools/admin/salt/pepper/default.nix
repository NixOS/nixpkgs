{ lib
, pythonPackages
, salt
}:

pythonPackages.buildPythonApplication rec {
  pname = "salt-pepper";
  version = "0.7.5";
  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1wh6yidwdk8jvjpr5g3azhqgsk24c5rlzmw6l86dmi0mpvmxm94w";
  };

  buildInputs = with pythonPackages; [ setuptools setuptools_scm salt ];
  checkInputs = with pythonPackages; [
    pytest mock pyzmq pytest-rerunfailures pytestcov cherrypy tornado_4
  ];

  meta = with lib; {
    description = "A CLI front-end to a running salt-api system";
    homepage = https://github.com/saltstack/pepper;
    maintainers = [ maintainers.pierrer ];
    license = licenses.asl20;
  };
}
