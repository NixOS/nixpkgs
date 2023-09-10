{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, clikit
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "5.1.1";
  pname = "xdg";
  disabled = isPy27;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "srstevenson";
    repo = pname;
    rev = version;
    hash = "sha256-z/Zvo2WGw9qA+M3Pt9r35DuxtuhL7/I75LlFEdDOJcc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    clikit
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "XDG Base Directory Specification for Python";
    homepage = "https://github.com/srstevenson/xdg";
    license = licenses.isc;
    maintainers = with maintainers; [ jonringer ];
  };
}
