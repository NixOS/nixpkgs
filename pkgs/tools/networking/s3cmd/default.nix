{ lib, buildPythonApplication, fetchFromGitHub, python-magic, python-dateutil }:

buildPythonApplication rec {
  pname = "s3cmd";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "s3tools";
    repo = "s3cmd";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-nb4WEH8ELaG/bIe4NtjD4p99VJoG90UQ662iWyvnr2U=";
  };

  propagatedBuildInputs = [ python-magic python-dateutil ];

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://s3tools.org/s3cmd";
    description = "Command line tool for managing Amazon S3 and CloudFront services";
    license = licenses.gpl2;
    maintainers = [ maintainers.spwhitt ];
  };
}
