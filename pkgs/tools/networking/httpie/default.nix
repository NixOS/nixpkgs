{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "httpie";
  version = "1.0.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "103fcigpxf4nqmrdqjnyz7d9n4n16906slwmmqqc0gkxv8hnw6vd";
  };

  propagatedBuildInputs = with python3Packages; [ pygments requests setuptools ];

  doCheck = false;

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = https://httpie.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod schneefux ];
  };
}
