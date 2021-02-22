{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, clikit
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "5.0.1";
  pname = "xdg";
  disabled = isPy27;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "srstevenson";
    repo = pname;
    rev = version;
    sha256 = "sha256-WMY9Hs9SbErTp8hVBoCWTz4dLQhuzqTRpXFEyE7+woo=";
  };

  nativeBuildInputs = [ poetry-core ];

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
