{ lib, python }:

python.pkgs.buildPythonApplication rec {
  pname = "alibuild";
  version = "1.11.2";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-wq2H2inUf2CjPD45krCNdjw2s4FXsEDlfOHqW8VaVKg=";
  };

  doCheck = false;
  propagatedBuildInputs = with python.pkgs; [
    requests
    pyyaml
    boto3
    jinja2
    distro
  ];

  meta = with lib; {
    homepage = "https://alisw.github.io/alibuild/";
    description = "Build tool for ALICE experiment software";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ktf ];
  };
}
