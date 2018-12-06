{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "httpie-1.0.0";

  src = fetchurl {
    url = "mirror://pypi/h/httpie/${name}.tar.gz";
    sha256 = "09cs2n76318i34vms9pdnbds53pnp1m11gwn444j49na5qnk8l0n";
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
