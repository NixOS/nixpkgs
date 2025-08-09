{
  lib,
  buildPythonPackage,
  fetchPypi,
  xorg,
  mock,
}:

buildPythonPackage rec {
  pname = "xvfbwrapper";
  version = "0.2.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ouR2yaTxlzf+Ky0LgB5m8P9wH9oz2YakvzTdxBR1QQI=";
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
