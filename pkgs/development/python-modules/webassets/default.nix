{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  nose,
  jinja2,
  mock,
  pytest,
}:

buildPythonPackage rec {
  pname = "webassets";
  version = "2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FnEyM3Z3yM7clwUJD21I2j+yYsjgsnc7KfM1LwUBgc0=";
  };

  propagatedBuildInputs = [ pyyaml ];
  nativeCheckInputs = [
    nose
    jinja2
    mock
    pytest
  ];

  # Needs Babel CLI tool
  doCheck = false;
  checkPhase = "py.test";

  meta = with lib; {
    description = "Media asset management for Python, with glue code for various web frameworks";
    mainProgram = "webassets";
    homepage = "https://github.com/miracle2k/webassets/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
