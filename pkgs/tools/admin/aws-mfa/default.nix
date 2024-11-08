{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
, setuptools
, boto3
}:

buildPythonApplication rec {
  pname = "aws-mfa";
  version = "0.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "broamski";
    repo = "aws-mfa";
    rev = version;
    hash = "sha256-XhnDri7QV8esKtx0SttWAvevE3SH2Yj2YMq/P4K6jK4=";
  };

  patches = [
    # https://github.com/broamski/aws-mfa/pull/87
    (fetchpatch {
      name = "remove-duplicate-script.patch";
      url = "https://github.com/broamski/aws-mfa/commit/0d1624022c71cb92bb4436964b87f0b2ffd677ec.patch";
      hash = "sha256-Bv8ffPbDysz87wLg2Xip+0yxaBfbEmu+x6fSXI8BVjA=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
  ];

  # package has no tests
  doCheck = false;

  pythonImportsCheck = [
    "awsmfa"
  ];

  meta = with lib; {
    description = "Manage AWS MFA Security Credentials";
    mainProgram = "aws-mfa";
    homepage = "https://github.com/broamski/aws-mfa";
    license = licenses.mit;
    maintainers = [ ];
  };
}
