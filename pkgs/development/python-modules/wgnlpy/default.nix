{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, cryptography
, pyroute2
}:

buildPythonPackage rec {
  pname = "wgnlpy";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vfYGjVrG/YkGhNO6jq89KNTf/hCv6++Flm/LH46uLow=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    pyroute2
  ];

  meta = with lib; {
    description = "A simple control interface for WireGuard via Netlink, written in Python.";
    homepage = "https://github.com/ArgosyLabs/wgnlpy";
    license = licenses.mit;
    maintainers = with maintainers; [ marcel ];
  };
}
