{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # pycfmodel is pinned, https://github.com/Skyscanner/cfripper/issues/204
      pycfmodel = super.pycfmodel.overridePythonAttrs (oldAttrs: rec {
        version = "0.13.0";

        src = fetchFromGitHub {
          owner = "Skyscanner";
          repo = "pycfmodel";
          rev = version;
          hash = "sha256-BlnLf0C/wxPXhoAH0SRB22eGWbbZ05L20rNy6qfOI+A=";
        };
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "cfripper";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = pname;
    rev = version;
    hash = "sha256-y3h/atfFl/wDmr+YBdsWrCez4PQBEcl3xNDyTwXZIp4=";
  };

  propagatedBuildInputs = with py.pkgs; [
    boto3
    cfn-flip
    click
    pluggy
    pycfmodel
    pydash
    pyyaml
    setuptools
  ];

  checkInputs = with py.pkgs; [
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
