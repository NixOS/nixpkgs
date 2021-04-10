{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apkid";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "rednaga";
    repo = "APKiD";
    rev = "v${version}";
    sha256 = "1p6kdjjw2jhwr875445w43k46n6zwpz0l0phkl8d3y1v4gi5l6dx";
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
    # The next release will have support for later yara-python releases
    substituteInPlace setup.py \
      --replace "yara-python==3.11.0" "yara-python"
  '';

  pythonImportsCheck = [ "apkid" ];

  meta = with lib; {
    description = "Android Application Identifier";
    homepage = "https://github.com/rednaga/APKiD";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
