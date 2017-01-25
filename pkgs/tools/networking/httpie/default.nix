{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "httpie-0.9.8";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/h/httpie/${name}.tar.gz";
    sha256 = "1qgn1mpkk8wxxhvgxw3fnscqg3klh42ijr11zrb0ylriaaqp0n2i";
  };

  propagatedBuildInputs = with pythonPackages; [ pygments requests2 ];

  doCheck = false;

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = http://httpie.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod schneefux ];
  };
}
