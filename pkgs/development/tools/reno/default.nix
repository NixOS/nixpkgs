{ stdenv, fetchurl, pythonPackages }:

with pythonPackages; buildPythonApplication rec {
  name = "reno-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = "mirror://pypi/r/reno/${name}.tar.gz";
    sha256 = "0cq6msiqx4g8azlwk8v6n0vvbngbqvjzskrq36dqkvcvaxaqc3py";
  };

  # Don't know how to make tests pass
  doCheck = false;

  # Nothing to strip (python files)
  dontStrip = true;

  propagatedBuildInputs = [ pbr six pyyaml dulwich ];
  buildInputs = [ Babel ];

  meta = with stdenv.lib; {
    description = "Release Notes Manager";
    homepage    = http://docs.openstack.org/developer/reno/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ guillaumekoenig ];
  };
}
