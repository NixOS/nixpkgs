{ lib, python3Packages, buildPythonApplication, fetchPypi}:

buildPythonApplication rec {
  pname = "xxh-xxh";
  version = "0.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NggUTiA1t9Oookhzs9106htEYIkpceJlUG/UYnStKXM=";
  };

  propagatedBuildInputs = with python3Packages; [
    pexpect
    pyyaml
  ];

  meta = with lib; {
    homepage = "https://github.com/xxh/xxh";
    description = "Tool to use your shell with remote SSH connections";
    license = licenses.bsd2;
    maintainers = with maintainers; [ travisdavis-ops ];
  };
}
