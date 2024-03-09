{ lib
, buildPythonPackage
, fetchPypi
, dnfile
, pefile
, click
, tqdm
, xxhash
, pyyaml
, urllib3
, platformdirs
, update-python-libraries
, setuptools
, setuptools-scm
} :

buildPythonPackage rec {
  pname = "everest-mons";
  version = "2.0.0";

  src = fetchPypi {
    inherit version;
    pname = "mons";
    hash = "sha256-E1yBTwZ4T2C3sXoLGz0kAcvas0q8tO6Aaiz3SHrT4ZE=";
  };

  build-system = [ setuptools-scm ];
  pyproject = true;
  propagatedBuildInputs = [
    dnfile
    pefile
    click
    tqdm
    xxhash
    pyyaml
    urllib3
    platformdirs
  ];

  meta = with lib; {
    homepage = "https://mons.coloursofnoise.ca/";
    description = "A commandline Everest installer and mod manager for Celeste";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "mons";
  };
}
