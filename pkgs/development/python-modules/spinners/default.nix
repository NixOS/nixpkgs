{ lib, fetchPypi, buildPythonPackage, termcolor, six
, log-symbols }:

buildPythonPackage rec {
  pname = "spinners";
  version = "0.0.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "HrautHgdcqtC7YoB3PIPMAK/UHQNcVTRL7jJdpv54n8=";
  };

  propagatedBuildInputs = [ termcolor six log-symbols ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  pythonImportsCheck = [ "spinners" ];

  meta = with lib; {
    description = "More than 60 spinners for terminal";
    homepage    = "https://github.com/manrajgrover/py-spinners";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
