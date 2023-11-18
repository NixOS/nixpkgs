{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, clikit
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "6.0.0";
  pname = "xdg";
  disabled = isPy27;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "srstevenson";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-yVuruSKv99IZGNCpY9cKwAe6gJNAWjL+Lol2D1/0hiI=";
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
