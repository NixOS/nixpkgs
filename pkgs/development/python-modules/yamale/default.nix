{ lib, buildPythonPackage, fetchFromGitHub, pytest, pyyaml, }:

buildPythonPackage rec {
  version = "2.2.0";
  pname = "yamale";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = "Yamale";
    rev = "${version}";
    sha256 = "1xhxy3xk4bhy0fcnqif5cj0rf2sd1ifa1z077gp01r4j9vb65s0q";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [ pytest ];

  meta = with lib; {
    description = "A schema and validator for YAML.";
    homepage = "https://github.com/23andMe/Yamale";
    license = licenses.mit;
    maintainers = with maintainers; [ chkno ];
  };
}
