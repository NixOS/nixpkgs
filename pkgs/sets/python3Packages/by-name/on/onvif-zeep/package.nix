{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zeep,
}:

buildPythonPackage rec {
  pname = "onvif-zeep";
  version = "0.2.12";
  pyproject = true;

  src = fetchPypi {
    pname = "onvif_zeep";
    inherit version;
    hash = "sha256-qou8Aqc+qlCJSwwY45+o0xilg6ZkxlvzWzyAKdHEC0k=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ zeep ];

  pythonImportsCheck = [ "onvif" ];

  # Tests require hardware
  doCheck = false;

  meta = {
    description = "Python Client for ONVIF Camera";
    mainProgram = "onvif-cli";
    homepage = "https://github.com/quatanium/python-onvif";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fleaz ];
  };
}
