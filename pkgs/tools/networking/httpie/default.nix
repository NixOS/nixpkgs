{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "httpie-0.9.9";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/h/httpie/${name}.tar.gz";
    sha256 = "1jsgfkyzzizgfy1b0aicb4cp34d5pwskz9c4a8kf4rq3lrpjw87i";
  };

  propagatedBuildInputs = with pythonPackages; [ pygments requests ];

  doCheck = false;

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = http://httpie.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod schneefux ];
  };
}
