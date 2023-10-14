{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytestCheckHook
}:

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
    # https://github.com/hongquan/single-version/pull/4
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/hongquan/single-version/commit/0cdf9795cb0522e90a8dc00306f1ff7bb85621ad.patch";
      hash = "sha256-eT9G1XvkNF0+NKgx+yN7ei53xIEMvnc7V/KtPLqlWik=";
    })
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
