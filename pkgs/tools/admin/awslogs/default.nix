{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "awslogs";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "jorgebastida";
    repo = "awslogs";
    rev = version;
    sha256 = "1gyry8b64psvmjcb2lb3yilpa7b17yllga06svls4hi69arvrd8f";
  };

  propagatedBuildInputs = with python3Packages; [
    boto3 termcolor python-dateutil docutils setuptools jmespath
  ];

  checkInputs = [ python3Packages.pytestCheckHook ];
  disabledTests = [
    "test_main_get_query"
    "test_main_get_with_color"
  ];

  meta = with lib; {
    homepage = "https://github.com/jorgebastida/awslogs";
    description = "AWS CloudWatch logs for Humans";
    maintainers = with maintainers; [ dbrock ];
    license = licenses.bsd3;
  };
}
