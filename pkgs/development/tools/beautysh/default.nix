{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "beautysh";
  version = "6.2.1";
  format = "pyproject";


  src = fetchFromGitHub {
    owner = "lovesegfault";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rPeGRcyNK45Y7OvtzaIH93IIzexBf/jM1SzYP0phQ1o=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    setuptools
    types-colorama
    types-setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'types-setuptools = "^57.4.0"' 'types-setuptools = "*"'
  '';

  pythonImportsCheck = [
    "beautysh"
  ];

  meta = with lib; {
    description = "Tool for beautifying Bash scripts";
    homepage = "https://github.com/lovesegfault/beautysh";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
