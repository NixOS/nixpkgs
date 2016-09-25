{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "SaltTesting-${version}";
  version = "2016.9.7";

  disabled = pythonPackages.isPy3k;

  src = fetchurl {
    url = "mirror://pypi/S/SaltTesting/${name}.tar.gz";
    sha256 = "0vcw1b1176qm9nkic3sbxh6vnv9kpd9kgyqz5fpsp5jnb2hsf1qx";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/saltstack/salt-testing;
    description = "Common testing tools used in the Salt Stack projects";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.asl20;
  };
}
