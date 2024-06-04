{
  lib,
  buildPythonPackage,
  fetchPypi,
  xorgserver,
  mock,
}:

buildPythonPackage rec {
  pname = "xvfbwrapper";
  version = "0.2.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "097wxhvp01ikqpg1z3v8rqhss6f1vwr399zpz9a05d2135bsxx5w";
  };
  propagatedBuildInputs = [ xorgserver ];

  # See: https://github.com/cgoldberg/xvfbwrapper/issues/30
  doCheck = false;

  nativeCheckInputs = [ mock ];

  meta = with lib; {
    description = "Run headless display inside X virtual framebuffer (Xvfb)";
    homepage = "https://github.com/cgoldberg/xvfbwrapper";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
