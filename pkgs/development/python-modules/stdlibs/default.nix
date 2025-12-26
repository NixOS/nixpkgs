{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage rec {
  pname = "stdlibs";
  version = "2025.10.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "stdlibs";
    tag = "v${version}";
    hash = "sha256-1xdwYwkQqkPsa5yjrTUM0HxRVLJ+ZQvYwFpjIlW7jaY=";
  };

  build-system = [ flit-core ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "stdlibs" ];

  meta = {
    description = "Overview of the Python stdlib";
    homepage = "https://github.com/omnilib/stdlibs";
    changelog = "https://github.com/omnilib/stdlibs/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
