{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, poetry-core
, pythonRelaxDepsHook
, requests
, urllib3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "synologydsm-api";
  version = "1.0.2";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "synologydsm-api";
    rev = "v${version}";
    hash = "sha256-UQdPwvRdv7SCOTxkA1bfskQ9oL/DB0j1TdJE04ODyj8=";
  };

  patches = [
    # https://github.com/hacf-fr/synologydsm-api/pull/84
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/hacf-fr/synologydsm-api/commit/f1ea2be927388bdff6d43d09027b82a854635e34.patch";
      hash = "sha256-+c25zLkTtjeX7IE+nZEnjrWfnDhDJpeHN7qRKO5rF4g=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "urllib3"
  ];

  propagatedBuildInputs = [
    requests
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "synology_dsm" ];

  meta = with lib; {
    description = "Python API for communication with Synology DSM";
    homepage = "https://github.com/hacf-fr/synologydsm-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
