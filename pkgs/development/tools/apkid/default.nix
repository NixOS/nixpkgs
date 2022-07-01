{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apkid";
  version = "2.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rednaga";
    repo = "APKiD";
    rev = "v${version}";
    hash = "sha256-U4CsPTA0fXCzj5iLTbLFGudAvewVCzxe4xl0osoBy5A=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    yara-python
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  preBuild = ''
    # Prepare the YARA rules
    ${python3.interpreter} prep-release.py
  '';

  postPatch = ''
    # We have dex support enabled in yara-python
    substituteInPlace setup.py \
      --replace "yara-python-dex>=1.0.1" "yara-python"
  '';

  pythonImportsCheck = [
    "apkid"
  ];

  meta = with lib; {
    description = "Android Application Identifier";
    homepage = "https://github.com/rednaga/APKiD";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
