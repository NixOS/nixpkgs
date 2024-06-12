{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "volatile";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "volatile";
    rev = "refs/tags/${version}";
    hash = "sha256-TYUvr0bscM/FaPk9oiF4Ob7HdKa2HlbpEFmaPfh4ir0=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "volatile" ];

  meta = with lib; {
    description = "Small extension for the tempfile module";
    homepage = "https://github.com/mbr/volatile";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
