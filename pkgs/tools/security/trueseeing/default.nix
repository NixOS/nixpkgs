{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trueseeing";
  version = "2.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alterakey";
    repo = "trueseeing";
    rev = "refs/tags/v${version}";
    hash = "sha256-g5OqdnPtGGV4wBwPRAjH3lweguwlfVcgpNLlq54OHKA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "attrs~=21.4" "attrs>=21.4"
  '';

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
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "trueseeing"
  ];

  meta = with lib; {
    description = "Non-decompiling Android vulnerability scanner";
    homepage = "https://github.com/alterakey/trueseeing";
    changelog = "https://github.com/alterakey/trueseeing/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
