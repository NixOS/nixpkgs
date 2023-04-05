{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "scdl";
  version = "2.7.3";
  format = "setuptools";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "60284b7b058040d4847f2e4b0ab906b10e959d51f976a0188641e8e10685474f";
  };

  propagatedBuildInputs = with python3Packages; [
    docopt
    mutagen
    termcolor
    requests
    clint
    pathvalidate
    soundcloud-v2
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "scdl" ];

  meta = with lib; {
    description = "Download Music from Souncloud";
    homepage = "https://github.com/flyingrub/scdl";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ marsam ];
  };
}
