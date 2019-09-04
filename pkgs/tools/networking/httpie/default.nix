{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "httpie";
  version = "1.0.3";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "103fcigpxf4nqmrdqjnyz7d9n4n16906slwmmqqc0gkxv8hnw6vd";
  };

  propagatedBuildInputs = with pythonPackages; [ pygments requests ];

  doCheck = false;

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = https://httpie.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod schneefux ];
  };
}
