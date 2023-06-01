{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trueseeing";
  version = "2.1.5";
  format = "flit";

  src = fetchFromGitHub {
    owner = "alterakey";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7iQOQ81k2bPBber4ewyvDy82s26j4P3Vv8MzSs04KAw=";
  };

  nativeBuildInputs = with python3.pkgs; [
    flit-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    ipython
    jinja2
    lxml
    pypubsub
    pyyaml
    docker
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "attrs~=21.4" "attrs>=21.4" \
      --replace "docker~=5.0.3" "docker"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "trueseeing"
  ];

  meta = with lib; {
    description = "Non-decompiling Android vulnerability scanner";
    homepage = "https://github.com/alterakey/trueseeing";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
