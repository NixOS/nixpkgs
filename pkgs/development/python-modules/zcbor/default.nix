{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build dependencies
  setuptools,

  # dependencies
  cbor2,
  pyyaml,
  regex,
}:

buildPythonPackage rec {
  pname = "zcbor";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wEkYOS4tuxTG8DjXduLqawnDS6ECiwRardfDqVYWvDg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cbor2
    pyyaml
    regex
  ];

  pythonImportsCheck = [ "zcbor" ];

  meta = {
    # upstream requires cbor<6.0.0
    # patch is unreleased and doesn't apply to 0.9.2
    # https://github.com/nordicsemi/zcbor/issues/667
    broken = true;
    description = "Low footprint CBOR library in the C language (C++ compatible), tailored for use in microcontrollers";
    mainProgram = "zcbor";
    homepage = "https://pypi.org/project/zcbor/";
    changelog = "https://github.com/NordicSemiconductor/zcbor/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
