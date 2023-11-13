{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "awslogs";
  version = "0.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jorgebastida";
    repo = pname;
    rev = version;
    sha256 = "sha256-DrW8s0omQqLp1gaoR6k/YR11afRjUbGYrFtfYhby2b8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    boto3
    termcolor
    python-dateutil
    docutils
    setuptools
    jmespath
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "jmespath>=0.7.1,<1.0.0" "jmespath>=0.7.1" \
      --replace '>=3.5.*' '>=3.5'
  '';

  disabledTests = [
    "test_main_get_query"
    "test_main_get_with_color"
  ];

  pythonImportsCheck = [
    "awslogs"
  ];

  meta = with lib; {
    description = "AWS CloudWatch logs for Humans";
    homepage = "https://github.com/jorgebastida/awslogs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dbrock ];
  };
}
