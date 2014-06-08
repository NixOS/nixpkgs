{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "httpie-0.8.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/h/httpie/${name}.tar.gz";
    sha256 = "16f3scm794plxbyw7a5b4541hb2psa85kfi98g83785i2qwz98ag";
  };

  propagatedBuildInputs = with pythonPackages; [ pygments requests2 ];

  doCheck = false;

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = http://httpie.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod ];
  };
}
