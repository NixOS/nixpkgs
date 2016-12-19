{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "reno-${version}";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://pypi/r/reno/${name}.tar.gz";
    sha256 = "1pqg0xzcilmyrrnpa87m11xwlvfc94a98s28z9cgddkhw27lg3ps";
  };

  # Don't know how to make tests pass
  doCheck = false;

  # Nothing to strip (python files)
  dontStrip = true;

  propagatedBuildInputs = with pythonPackages; [ pbr six pyyaml ];
  buildInputs = with pythonPackages; [ Babel ];

  meta = with stdenv.lib; {
    description = "Release Notes Manager";
    homepage    = http://docs.openstack.org/developer/reno/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ guillaumekoenig ];
  };
}
