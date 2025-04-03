{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-psutil";
  version = "7.0.0.20250218";
  format = "setuptools";

  src = fetchPypi {
    pname = "types_psutil";
    inherit version;
    hash = "sha256-HmQs2v6DeyQClbI7HL1GkdgLCKB9KZMhQ8u64w6w25w=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "psutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for psutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
