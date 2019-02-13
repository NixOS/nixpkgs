{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "awslogs";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "jorgebastida";
    repo = "awslogs";
    rev = "${version}";
    sha256 = "0vdpld7r7y78x1lcd5z3qsx047dwichxb8f3447yzl75fnsm75dc";
  };

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    boto3 termcolor dateutil docutils
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jorgebastida/awslogs;
    description = "AWS CloudWatch logs for Humans";
    maintainers = with maintainers; [ dbrock ];
    license = licenses.bsd3;
  };
}
