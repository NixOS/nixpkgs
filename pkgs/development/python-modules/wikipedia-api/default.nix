{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wikipedia-api";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "martin-majlis";
    repo = "Wikipedia-API";
    rev = "v${version}";
    hash = "sha256-cmwyQhKbkIpZXkKqqT0X2Lp8OFma2joeb4uxDRPiQe8=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wikipediaapi" ];

  meta = with lib; {
    description = "Python wrapper for Wikipedia";
    homepage = "https://github.com/martin-majlis/Wikipedia-API";
    changelog = "https://github.com/martin-majlis/Wikipedia-API/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
