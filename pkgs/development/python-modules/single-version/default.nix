{ lib, buildPythonPackage, fetchFromGitHub, poetry-core, pytestCheckHook }:

buildPythonPackage rec {
  pname = "single-version";
  version = "1.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hongquan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-I8ATQzPRH9FVjqPoqrNjYMBU5azpmkLjRmHcz943C10=";
  };

  patches = [
    ./0001-set-poetry-core.patch
  ];

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "single_version" ];

  meta = with lib; {
    description = "Utility to let you have a single source of version in your code base";
    homepage = "https://github.com/hongquan/single-version";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
