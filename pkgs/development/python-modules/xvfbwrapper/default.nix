{
  lib,
  buildPythonPackage,
  fetchPypi,
  xorg,
  mock,
}:

buildPythonPackage rec {
  pname = "xvfbwrapper";
  version = "0.2.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vPSuVxlBtAJU+venNDLfwRmtIc5ojx/exTMGcDfs/CQ=";
  };
  propagatedBuildInputs = [ xorg.xvfb ];

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
