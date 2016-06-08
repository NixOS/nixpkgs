{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "httpie-0.9.3";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/h/httpie/${name}.tar.gz";
    sha256 = "0jvzxr8r6cy6ipknkw95qf8rz69nqdv5nky87h1vcp5pf8mgza1h";
  };

  propagatedBuildInputs = with pythonPackages; [ pygments requests2 curses ];

  doCheck = false;

  meta = {
    description = "A command line HTTP client whose goal is to make CLI human-friendly";
    homepage = http://httpie.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ antono relrod ];
  };
}
