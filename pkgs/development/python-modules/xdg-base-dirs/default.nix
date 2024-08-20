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
  version = "6.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "srstevenson";
    repo = "xdg-base-dirs";
    rev = version;
    hash = "sha256-nbdF1tjVqlxwiGW0pySS6HyJbmNuQ7mVdQYfhofO4Dk=";
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
    changelog = "https://github.com/srstevenson/xdg-base-dirs/releases/tag/${src.rev}";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
  };
}
