{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "s3cmd-${version}";
  version = "1.6.1";
  
  src = fetchFromGitHub {
    owner  = "s3tools";
    repo   = "s3cmd";
    rev    = "v${version}";
    sha256 = "0aan6v1qj0pdkddhhkbaky44d54irm1pa8mkn52i2j86nb2rkcf9";
  };

  propagatedBuildInputs = with pythonPackages; [ python_magic dateutil ];

  meta = with stdenv.lib; {
    homepage = http://s3tools.org/;
    description = "A command-line tool to manipulate Amazon S3 buckets";
    license = licenses.gpl2;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.all;
  };
}
