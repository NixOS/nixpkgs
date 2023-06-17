{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apkid";
  version = "2.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rednaga";
    repo = "APKiD";
    rev = "refs/tags/v${version}";
    hash = "sha256-ASxly2dH+TnwvU3CYD52XbC79n2dku01j3+YHOZ745U=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    yara-python
  ];

  nativeCheckInputs = with python3.pkgs; [
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
