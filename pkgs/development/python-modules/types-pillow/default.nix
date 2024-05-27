{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-pillow";
  version = "10.2.0.20240415";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types-Pillow";
    hash = "sha256-3WBYAnY5vNxmuniyKMwl/a5CUkwhUMeMgE2kJ+fnbnA=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "PIL-stubs" ];

  meta = with lib; {
    description = "Typing stubs for Pillow";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ arjan-s ];
  };
}
