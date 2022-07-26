{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "mloader";
  version = "1.1.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "81e4dc7117999d502e3345f8e32df8b16cca226b8b508976dde2de81a4cc2b19";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    protobuf
    requests
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "mloader" ];

  meta = with lib; {
    description = "Command-line tool to download manga from mangaplus";
    homepage = "https://github.com/hurlenko/mloader";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marsam ];
  };
}
