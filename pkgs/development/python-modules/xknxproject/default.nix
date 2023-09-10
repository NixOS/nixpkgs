{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, pythonOlder
, pyzipper
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "xknxproject";
  version = "3.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknxproject";
    rev = "refs/tags/${version}";
    hash = "sha256-ZLBvhuLXEOgqS7tRwP/e1Dv1/EMqxqXgpAZtLQGIt/o=";
  };

  patches = [
    (fetchpatch {
      name = "unpin-setuptools.patch";
      url = "https://github.com/XKNX/xknxproject/commit/53fecaf757d682fda00b04c3a2a1f3da86d9705f.patch";
      hash = "sha256-EpfgEq4pIx7ahqJZalzo30ruj8NlZYHcKHxFXCGL98w=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    cryptography
    pyzipper
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xknxproject"
  ];

  meta = with lib; {
    description = "ETS project parser";
    homepage = "https://github.com/XKNX/xknxproject";
    changelog = "https://github.com/XKNX/xknxproject/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
