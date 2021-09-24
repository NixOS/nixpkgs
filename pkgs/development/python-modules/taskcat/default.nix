{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, reprint
, mock
, tabulate
, cfn-lint
, setuptools
, boto3
, botocore
, yattag
, pyyaml
, jinja2
, requests
, jsonschema
, docker
, dulwich
, dataclasses-jsonschema
, pip
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "taskcat";
  version = "0.9.29";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "aws-quickstart";
    repo = pname;
    rev = version;
    sha256 = "1yi442xs628vibjss4v3ffglgpgkqzdmln7295jcgy5r3zg1f6br";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "jinja2>=2.10.0,<3.0" jinja2 \
      --replace "docker~=4.0" docker \
      --replace "mock>=2.0.0,<3.0" mock
  '';

  propagatedBuildInputs = [
    reprint
    mock
    tabulate
    cfn-lint
    setuptools
    boto3
    botocore
    yattag
    pyyaml
    jinja2
    requests
    jsonschema
    docker
    dulwich
    dataclasses-jsonschema
    pip
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # These tests try to connect to a docker daemon
  disabledTests = [
    "test_package"
    "test_nested_submodules"
    "test_amiupdater_region_regex_matches_all_published_regions"
  ];

  pythonImportsCheck = [
    "taskcat"
  ];

  meta = with lib; {
    description = "Test all the CloudFormation things! (with TaskCat)";
    homepage = "https://github.com/aws-quickstart/taskcat";
    license = licenses.asl20;
    maintainers = with maintainers; [ glittershark ];
  };
}
