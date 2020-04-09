{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "s3cmd";
  version = "2.1.0";
  
  src = fetchFromGitHub {
    owner  = "s3tools";
    repo   = "s3cmd";
    rev    = "v${version}";
    sha256 = "0p6mbgai7f0c12pkw4s7d649gj1f8hywj60pscxvj9jsna3iifhs";
  };

  propagatedBuildInputs = with python2Packages; [ python_magic dateutil ];

  meta = with stdenv.lib; {
    homepage = "http://s3tools.org/";
    description = "A command-line tool to manipulate Amazon S3 buckets";
    license = licenses.gpl2;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.all;
  };
}
