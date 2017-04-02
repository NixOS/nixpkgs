{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "awslogs-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "jorgebastida";
    repo = "awslogs";
    rev = "${version}";
    sha256 = "0dqf26h595l1fcnagxi8zsdarsxg3smsihxaqrvnki8fshhfdqsm";
  };

  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [
    boto3 termcolor dateutil docutils
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jorgebastida/awslogs;
    description = "AWS CloudWatch logs for Humans";
    maintainers = with maintainers; [ dbrock ];
    license = licenses.bsd3;
  };
}
