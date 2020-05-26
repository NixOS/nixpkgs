{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, clikit
, poetry
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "4.0.1";
  pname = "xdg";
  disabled = isPy27;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "srstevenson";
    repo = pname;
    rev = version;
    sha256 = "13kgnbwam6wmdbig0m98vmyjcqrp0j62nmfknb6prr33ns2nxbs2";
  };

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    clikit
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "XDG Base Directory Specification for Python";
    homepage = "https://github.com/srstevenson/xdg";
    license = licenses.isc;
    maintainers = with maintainers; [ jonringer ];
  };
}
