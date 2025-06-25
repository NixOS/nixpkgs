{
  lib,
  buildPythonPackage,
  fetchPypi,
  xorg,
  mock,
}:

buildPythonPackage rec {
  pname = "xvfbwrapper";
  version = "0.2.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1mLPjyZu/T0KHAIu67jSwECD1uh/2BOS+1QA2VA27Yw=";
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
