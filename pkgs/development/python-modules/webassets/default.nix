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
    sha256 = "1kc1042jydgk54xpgcp0r1ib4gys91nhy285jzfcxj3pfqrk4w8n";
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
