{ lib, buildPythonApplication, fetchFromGitHub, python-magic, python-dateutil }:

buildPythonApplication rec {
  pname = "s3cmd";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "s3tools";
    repo = "s3cmd";
    rev = "v${version}";
    sha256 = "0w4abif05mp52qybh4hjg6jbbj2caljq5xdhfiha3g0s5zsq46ri";
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
