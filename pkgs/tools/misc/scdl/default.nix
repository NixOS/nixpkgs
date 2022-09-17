{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "scdl";
  version = "2.7.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "7d6212591a5bccf017424f732535475fb9ae3bab26a4fb5bc36064962d33f8e0";
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
