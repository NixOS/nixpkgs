{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zipstream-ng";
  version = "1.3.4";

  disabled = pythonOlder "3.7";
  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "zipstream-ng";
    rev = "v${version}";
    sha256 = "NTsnGCddGDUxdHbEoM2ew756psboex3sb6MkYKtaSjQ=";
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
