{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xdg-base-dirs";
  version = "6.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "srstevenson";
    repo = "xdg-base-dirs";
    rev = version;
    hash = "sha256-yVuruSKv99IZGNCpY9cKwAe6gJNAWjL+Lol2D1/0hiI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xdg_base_dirs" ];

  meta = with lib; {
    description = "An implementation of the XDG Base Directory Specification in Python";
    homepage = "https://github.com/srstevenson/xdg-base-dirs";
    changelog = "https://github.com/srstevenson/xdg-base-dirs/releases/tag/${src.rev}";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
  };
}
