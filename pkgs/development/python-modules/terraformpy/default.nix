{ lib,
  fetchFromGitHub,
  buildPythonPackage,
  schematics,
  six,
  pytest,
  pytest-mock,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "terraformpy";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "NerdWalletOSS";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cm7t2H7g01cptNspgTr3NI8Fk1ryWEUwdGnLZC1cN6A=";
  };

  propagatedBuildInputs = [
    six
    schematics
  ];

  checkInputs = [
    pytest
    pytest-cov
    pytest-mock
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Terraformpy is a library and command line tool to supercharge your Terraform configs using a full fledged Python environment";
    homepage = "https://github.com/NerdWalletOSS/terraformpy";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
