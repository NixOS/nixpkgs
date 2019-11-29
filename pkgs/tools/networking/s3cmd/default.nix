{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "s3cmd";
  version = "2.0.2";
  
  src = fetchFromGitHub {
    owner  = "s3tools";
    repo   = "s3cmd";
    rev    = "v${version}";
    sha256 = "0ninw830309cxga99gjnfghpkywf9kd6yz4wqsq85zni1dv39cdk";
  };

  propagatedBuildInputs = with python2Packages; [ python_magic dateutil ];

  meta = with stdenv.lib; {
    homepage = http://s3tools.org/;
    description = "A command-line tool to manipulate Amazon S3 buckets";
    license = licenses.gpl2;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.all;
  };
}
