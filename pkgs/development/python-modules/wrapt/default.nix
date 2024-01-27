{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, sphinxHook
, sphinx-rtd-theme
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.16.0";
  outputs = [ "out" "doc" ];
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lVpSriXSvRwAKX4iPOIBvJwhqhKjdrUdGaEG4QoTQyo=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  pythonImportsCheck = [
    "wrapt"
  ];

  meta = with lib; {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
