{
  lib,
  buildPythonPackage,
  dpath,
  fetchFromGitHub,
  plac,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "yte";
  version = "1.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "koesterlab";
    repo = "yte";
    rev = "refs/tags/v${version}";
    hash = "sha256-Rm3EKxRZCdYErkyWK9+fF2W7C+v5/MXD/LkehmB6UNQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    dpath
    plac
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yte" ];

  pytestFlagsArray = [ "tests.py" ];

  preCheck = ''
    # The CLI test need yte on the PATH
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "YAML template engine with Python expressions";
    mainProgram = "yte";
    homepage = "https://github.com/koesterlab/yte";
    changelog = "https://github.com/yte-template-engine/yte/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
