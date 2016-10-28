{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "httpie-0.9.6";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/h/httpie/${name}.tar.gz";
    sha256 = "1cch5y0hr9qpfn9m4nw5796c2x7v3m1ni4psjm26ajsl8pw90jx6";
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
