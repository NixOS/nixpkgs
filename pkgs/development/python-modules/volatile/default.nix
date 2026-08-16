{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "volatile";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "volatile";
    tag = finalAttrs.version;
    hash = "sha256-TYUvr0bscM/FaPk9oiF4Ob7HdKa2HlbpEFmaPfh4ir0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "volatile" ];

  meta = {
    description = "Small extension for the tempfile module";
    homepage = "https://github.com/mbr/volatile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
