{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "wheel-filename";
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M3XGHG733X5qKuMS6mvFSFHYOwWPaBMXw+w0eYo6ByE=";
  };

  patches = [
    (fetchpatch {
      name = "remove-wheel-dependency-constraint.patch";
      url = "https://github.com/jwodder/wheel-filename/commit/11cfa57c8a32fa2a52fb5fe537859997bb642e75.patch";
      hash = "sha256-ssePCVlJuHPJpPyFET3FnnWRlslLnZbnfn42g52yVN4=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "wheel_filename" ];

  meta = with lib; {
    description = "Parse wheel filenames";
    mainProgram = "wheel-filename";
    homepage = "https://github.com/jwodder/wheel-filename";
    license = with licenses; [ mit ];
    maintainers = with lib.maintainers; [ ayazhafiz ];
  };
}
