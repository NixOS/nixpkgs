{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "volatile";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "volatile";
    tag = version;
    hash = "sha256-TYUvr0bscM/FaPk9oiF4Ob7HdKa2HlbpEFmaPfh4ir0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "volatile" ];

  meta = {
    description = "Small extension for the tempfile module";
    homepage = "https://github.com/mbr/volatile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
