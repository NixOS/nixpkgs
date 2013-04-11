{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "httpie-0.4.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/h/httpie/${name}.tar.gz";
    sha256 = "1qd03vd4657vdvkfhbd2wnlz4xh6hyw75m7wmfhgac5m2028y3cv";
  };

  propagatedBuildInputs = with pythonPackages; [ pygments requests ];

  doCheck = false;

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = http://httpie.org/;
    license = "BSD";
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
