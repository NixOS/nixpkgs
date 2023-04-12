{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zipstream-ng";
  version = "1.5.0";

  disabled = pythonOlder "3.7";
  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "zipstream-ng";
    rev = "v${version}";
    hash = "sha256-4pS2t5IEIUHGJRaO6f9r8xnvXWA6p1EsDQ/jpD8CMLI=";
  };

  pythonImportsCheck = [
    "zipstream"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Library to generate streamable zip files";
    longDescription = ''
      A modern and easy to use streamable zip file generator. It can package and stream many files
      and folders on the fly without needing temporary files or excessive memory
    '';
    homepage = "https://github.com/pR0Ps/zipstream-ng";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ gador ];
  };
}
