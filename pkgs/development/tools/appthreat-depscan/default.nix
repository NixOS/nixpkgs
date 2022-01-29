{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "appthreat-depscan";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = "dep-scan";
    rev = "v${version}";
    hash = "sha256-HCOS8/jn7BOzDwSpenVGo6QpI/1ey6L1zBucTyqsSY4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appthreat-vulnerability-db
    defusedxml
    pyyaml
    rich
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov-append --cov-report term --cov depscan" ""
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # Assertion Error
    "test_query_metadata2"
  ];

  pythonImportsCheck = [
    "depscan"
  ];

  meta = with lib; {
    description = "Tool to audit dependencies based on known vulnerabilities and advisories";
    homepage = "https://github.com/AppThreat/dep-scan";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
