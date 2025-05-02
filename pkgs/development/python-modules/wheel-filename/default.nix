{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  hatchling,
}:

buildPythonPackage rec {
  pname = "wheel-filename";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "wheel-filename";
    tag = "v${version}";
    hash = "sha256-KAuUrrSq6HJAy+5Gj6svI4M6oV6Fsle1A79E2q2FKW8=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "wheel_filename" ];

  meta = with lib; {
    description = "Parse wheel filenames";
    mainProgram = "wheel-filename";
    homepage = "https://github.com/jwodder/wheel-filename";
    license = with licenses; [ mit ];
    maintainers = with lib.maintainers; [ ayazhafiz ];
  };
}
