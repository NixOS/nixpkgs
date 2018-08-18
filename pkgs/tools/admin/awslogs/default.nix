{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "awslogs";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "jorgebastida";
    repo = "awslogs";
    rev = "${version}";
    sha256 = "18s3xxdhhbz96mgj9ipgyrdcax3p9gy8gpmr0rblw8g0grj31dsp";
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
