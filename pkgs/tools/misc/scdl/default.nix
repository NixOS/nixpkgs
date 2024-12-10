{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "scdl";
  version = "2.7.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/QQb8xbi0rv5dU3WFr/hm2BuM/iDZ2OhrGjuqsQMqdk=";
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
    maintainers = with maintainers; [ ];
    mainProgram = "scdl";
  };
}
