{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "das";
  version = "0.3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snovvcrash";
    repo = "DivideAndScan";
    rev = "refs/tags/v${version}";
    hash = "sha256-UFuIy19OUiS8VmmfGm0F4hI4s4BU5b4ZVh40bFGiLfk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'networkx = "^2.8.4"' 'networkx = "*"'
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dash
    defusedxml
    dnspython
    netaddr
    networkx
    pandas
    plotly
    python-nmap
    scipy
    tinydb
  ];

  pythonImportsCheck = [
    "das"
  ];

  meta = with lib; {
    description = "Divide full port scan results and use it for targeted Nmap runs";
    homepage = "https://github.com/snovvcrash/DivideAndScan";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
