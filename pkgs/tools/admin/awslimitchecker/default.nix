{ pkgs, lib, python3, fetchFromGitHub }:

with pkgs; python3.pkgs.buildPythonApplication rec {
  pname = "awslimitchecker";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "jantman";
    repo = "awslimitchecker";
    rev = version;
    sha256 = "1p6n4kziyl6sfq7vgga9v88ddwh3sgnfb1m1cx6q25n0wyl7phgv";
  };

  propagatedBuildInputs = with python3Packages; [
    boto3
    botocore
    freezegun
    onetimepass
    pyotp
    pytz
    termcolor
    testfixtures
    versionfinder
  ];

  meta = with lib; {
    homepage = "http://awslimitchecker.readthedocs.org";
    changelog = "https://github.com/jantman/awslimitchecker/blob/${version}/CHANGES.rst";
    description = "A script and python package to check your AWS service limits and usage via boto3";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ zakame ];
  };
}
