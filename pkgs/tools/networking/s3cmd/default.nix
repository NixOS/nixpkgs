{ stdenv, buildPythonApplication, fetchFromGitHub, python_magic, dateutil }:

buildPythonApplication rec {
  pname = "s3cmd";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "s3tools";
    repo = "s3cmd";
    rev = "v${version}";
    sha256 = "0p6mbgai7f0c12pkw4s7d649gj1f8hywj60pscxvj9jsna3iifhs";
  };

  propagatedBuildInputs = [ python_magic dateutil ];

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://s3tools.org/s3cmd";
    description = "Command line tool for managing Amazon S3 and CloudFront services";
    license = licenses.gpl2;
    maintainers = [ maintainers.spwhitt ];
  };
}
