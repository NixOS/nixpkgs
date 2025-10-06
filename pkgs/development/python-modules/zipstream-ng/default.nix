{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zipstream-ng";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "zipstream-ng";
    tag = "v${version}";
    hash = "sha256-dkSTZkj6Rx6OMdlX4oDOydetosf/iEJhlARmEc0W9gQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zipstream" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Library to generate streamable zip files";
    mainProgram = "zipserver";
    longDescription = ''
      A modern and easy to use streamable zip file generator. It can package and stream many files
      and folders on the fly without needing temporary files or excessive memory
    '';
    homepage = "https://github.com/pR0Ps/zipstream-ng";
    changelog = "https://github.com/pR0Ps/zipstream-ng/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ gador ];
  };
}
