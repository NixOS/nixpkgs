{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "httpie-0.9.2";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/h/httpie/${name}.tar.gz";
    sha256 = "0s0dsj1iimn17h0xyziwk4kz4ga9s0vy9rhzixh8dna32za84fdg";
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
