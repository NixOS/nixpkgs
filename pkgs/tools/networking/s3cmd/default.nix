{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  python-magic,
  python-dateutil,
}:

buildPythonApplication rec {
  pname = "s3cmd";
  version = "2.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "s3tools";
    repo = "s3cmd";
    tag = "v${version}";
    sha256 = "sha256-cxwf6+9WFt3U7+JdKRgZxFElD+Dgf2P2VyejHVoiDJk=";
  };

  propagatedBuildInputs = [
    python-magic
    python-dateutil
  ];

  meta = with lib; {
    homepage = "https://s3tools.org/s3cmd";
    description = "Command line tool for managing Amazon S3 and CloudFront services";
    mainProgram = "s3cmd";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
