{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cfripper";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-qrZlCxNLO+q5n/FS/5b51QZVg4ZDwrgWpcKVp/JLTws=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    boto3
    cfn-flip
    click
    pluggy
    pycfmodel
    pydash
    pyyaml
    setuptools
  ];

  checkInputs = with python3.pkgs; [
    moto
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click~=7.1.1" "click" \
      --replace "pluggy~=0.13.1" "pluggy" \
      --replace "pydash~=4.7.6" "pydash"
  '';

  disabledTestPaths = [
    # Tests are failing
    "tests/test_boto3_client.py"
    "tests/config/test_pluggy.py"
  ];

  pythonImportsCheck = [
    "cfripper"
  ];

  meta = with lib; {
    description = "Tool for analysing CloudFormation templates";
    homepage = "https://github.com/Skyscanner/cfripper";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
