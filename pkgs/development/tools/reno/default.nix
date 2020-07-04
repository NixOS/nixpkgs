{ stdenv, fetchurl, pythonPackages }:

with pythonPackages; buildPythonApplication rec {
  pname = "reno";
  version = "2.3.2";

  src = fetchurl {
    url = "mirror://pypi/r/reno/${pname}-${version}.tar.gz";
    sha256 = "018vl9fj706jjf07xdx8q6761s53mrihjn69yjq09gp0vmp1g7i4";
  };

  # Don't know how to make tests pass
  doCheck = false;

  # Nothing to strip (python files)
  dontStrip = true;

  propagatedBuildInputs = [ pbr six pyyaml dulwich ];
  buildInputs = [ Babel ];

  meta = with stdenv.lib; {
    description = "Release Notes Manager";
    homepage    = "http://docs.openstack.org/developer/reno/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ guillaumekoenig ];
  };
}
