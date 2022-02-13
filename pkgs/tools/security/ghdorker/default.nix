{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ghdorker";
  version = "0.3.2";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-wF4QoXxH55SpdYgKLHf4sCwUk1rkCpSdnIX5FvFi/BU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    ghapi
    glom
    python-dotenv
    pyyaml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "GHDorker"
  ];

  meta = with lib; {
    description = "Extensible GitHub dorking tool";
    homepage = "https://github.com/dtaivpp/ghdorker";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
