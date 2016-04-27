{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "SaltTesting-${version}";
  version = "2015.7.10";

  disabled = pythonPackages.isPy3k;

  propagatedBuildInputs = with pythonPackages; [
    six
  ];

  src = fetchurl {
    url = "mirror://pypi/S/SaltTesting/${name}.tar.gz";
    sha256 = "0p0y8kb77pis18rcig1kf9dnns4bnfa3mr91q40lq4mw63l1b34h";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/saltstack/salt-testing;
    description = "Common testing tools used in the Salt Stack projects";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.asl20;
  };
}
