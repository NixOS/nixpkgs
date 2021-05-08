{ lib
, buildPythonApplication
, fetchFromGitHub
, boto3
}:

buildPythonApplication rec {
  pname = "aws-mfa";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "broamski";
    repo = "aws-mfa";
    rev = version;
    sha256 = "1blcpa13zgyac3v8inc7fh9szxq2avdllx6w5ancfmyh5spc66ay";
  };

  propagatedBuildInputs = [
    boto3
  ];

  doCheck = false;

  pythonImportsCheck = [
    "awsmfa"
  ];

  meta = with lib; {
    description = "Manage AWS MFA Security Credentials";
    homepage = "https://github.com/broamski/aws-mfa";
    license = [ licenses.mit ];
    maintainers = [ maintainers.srapenne ];
  };
}
