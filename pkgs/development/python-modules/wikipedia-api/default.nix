{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wikipedia-api";
  version = "0.7.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "martin-majlis";
    repo = "Wikipedia-API";
    tag = "v${version}";
    hash = "sha256-2vU4X8Qjv13e2aBiKJdZDgUKnmyp7vZ0U5BZVLhbc80=";
  };

  propagatedBuildInputs = [ requests ];

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
