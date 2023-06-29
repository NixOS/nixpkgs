{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-runner
, setuptools-scm
}:

buildPythonPackage rec {
  version = "1.2.2";
  pname = "ThorlabsPM100";

  src = fetchPypi {
    inherit pname version;
    sha256 = "881cec8149b17c77d4af0097ee3fdb40eaeb618c876d49f1bc42c87611737967";
  };

  propagatedBuildInputs = [
    setuptools-scm
    pytest-runner
  ];

  meta = with lib; {
    description = "Interface to the PM100A/D power meter from Thorlabs";
    homepage = "https://github.com/clade/ThorlabsPM100/";
    license = licenses.bsd1;
    maintainers = with maintainers; [ fsagbuya ];
  };
}
