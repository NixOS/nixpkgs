{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "sixelcrop";
  version = "0.1.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1sBaxPvW4gH3lK3tEjAPtCdXMXLAVEof0lpIpmpbyG8=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "sixelcrop"
  ];

  meta = {
    description = "Crop sixel images in sixel-space!";
    homepage = "https://github.com/joouha/sixelcrop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      euxane
      renesat
    ];
  };
}
