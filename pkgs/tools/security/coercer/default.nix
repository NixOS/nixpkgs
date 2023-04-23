{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "coercer";
  version = "1.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "Coercer";
    rev = "refs/tags/${version}";
    hash = "sha256-xftYnwu6uUTvJTZU9E7wvdgBxqa8xy83K5GOlgNSCvc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    impacket
  ];

  pythonImportsCheck = [
    "coercer"
  ];

  meta = with lib; {
    description = "Tool to automatically coerce a Windows server";
    homepage = "https://github.com/p0dalirius/Coercer";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
