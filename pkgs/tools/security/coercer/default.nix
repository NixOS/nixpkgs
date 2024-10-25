{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "coercer";
  version = "2.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "Coercer";
    rev = "refs/tags/${version}";
    hash = "sha256-WeaKToKYIB+jjTNIQvAUQQNb25TsNWALYZwIZuBjkPE=";
  };

  pythonRelaxDeps = [ "impacket" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    impacket
    xlsxwriter
  ];

  pythonImportsCheck = [ "coercer" ];

  # this file runs into issues on case-insensitive filesystems
  # ValueError: Both <...>/coercer and <...>/coercer.py exist
  postPatch = ''
    rm Coercer.py
  '';

  meta = with lib; {
    description = "Tool to automatically coerce a Windows server";
    homepage = "https://github.com/p0dalirius/Coercer";
    changelog = "https://github.com/p0dalirius/Coercer/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "coercer";
  };
}
