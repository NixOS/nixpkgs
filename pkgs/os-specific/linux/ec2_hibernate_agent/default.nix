{ lib, python3, python3Packages, fetchFromGitHub, coreutils }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "ec2-hibernate-linux-agent";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "149cb45404c0f75f5fa634fbca7289132ff423e0";
    sha256 = "1wivhn8y2f61q297hrckbn4fj8r56agv4l7qjk5xd6szbx11z1in";
  };

  prePatch = ''
    substituteInPlace test/hibagent_test.py \
      --replace /usr/bin/touch ${coreutils}/bin/touch
  '';

  checkInputs = with python3Packages; [ pytest ];

  meta = with lib; {
    description = "A Hibernating Agent for Linux on Amazon EC2 ";
    homepage = https://github.com/aws/ec2-hibernate-linux-agent;
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
    platforms = [ "x86_64-linux" ];
  };
}
