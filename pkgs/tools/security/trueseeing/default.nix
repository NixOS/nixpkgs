{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trueseeing";
  version = "2.1.4";
  format = "flit";

  src = fetchFromGitHub {
    owner = "alterakey";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zc0AOv7OFmEPLl//eykbh538rM2j4kXBLHt5bgK1IRY=";
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
  ];

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
