{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xdg-base-dirs";
  version = "6.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "srstevenson";
    repo = "xdg-base-dirs";
    rev = "refs/tags/${version}";
    hash = "sha256-iXK9WURTfmpl5vd7RsT0ptwfrb5UQQFqMMCu3+vL+EY=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xdg_base_dirs" ];

  # remove coverage flags from pytest config
  postPatch = ''
    sed -i /addopts/d pyproject.toml
  '';

  meta = with lib; {
    description = "Implementation of the XDG Base Directory Specification in Python";
    homepage = "https://github.com/srstevenson/xdg-base-dirs";
    changelog = "https://github.com/srstevenson/xdg-base-dirs/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
  };
}
