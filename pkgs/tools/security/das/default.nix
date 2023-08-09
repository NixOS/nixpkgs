{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "das";
  version = "0.3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "snovvcrash";
    repo = "DivideAndScan";
    rev = "refs/tags/v${version}";
    hash = "sha256-a9gnEBTvZshw42M/GrpCgjZh6FOzL45aZqGRyeHO0ec=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'networkx = "^2.8.4"' 'networkx = "*"' \
      --replace 'pandas = "^1.4.2"' 'pandas = "*"'
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
