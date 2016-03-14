{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "s3cmd-1.5.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/s3tools/${name}.tar.gz";
    sha256 = "0bdl2wvh4nri4n6hpaa8s9lk98xy4a1b0l9ym54fvmxxx1j6g2pz";
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
