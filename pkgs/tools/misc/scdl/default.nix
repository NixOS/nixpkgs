{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "scdl";
  version = "2.7.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YoQaIbOfwLtkSZJGZd9CL7TZGgqjfohJfrnQ3t5uLU0=";
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
    mainProgram = "scdl";
  };
}
