{
  fetchurl,
  lib,
  buildPythonPackage,
  # Dependencies
  torch,
  packaging,
}:
buildPythonPackage rec {
  pname = "torch-complex";
  version = "0.4.4";
  src = fetchurl {
    url = "https://pypi.org/packages/source/t/torch_complex/torch_complex-${version}.tar.gz";
    hash = "sha256-QVP9aySgutaJ5vGTv70A84KDsYkNgIvvaE3cbR9j/T8=";
  };

  propagatedBuildInputs = [
    torch
    packaging
  ];

  postPatch = ''
    substituteInPlace "setup.py" \
      --replace-fail "'pytest-runner'" ""
  '';

  pythonImportsCheck = [ "torch_complex" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Temporal python class for PyTorch-ComplexTensor";
    homepage = "https://pypi.org/project/torch-complex";
    license = with lib.licenses; [ asl20 ];
  };
}
