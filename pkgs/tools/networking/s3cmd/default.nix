{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "s3cmd-${version}";
  version = "2.0.1";
  
  src = fetchFromGitHub {
    owner  = "s3tools";
    repo   = "s3cmd";
    rev    = "v${version}";
    sha256 = "198hzzplci57sb8hdan30nbakslawmijfw0j71wjvq85n3xn6qsl";
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
