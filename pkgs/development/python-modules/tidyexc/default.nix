{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  flit-core_3,
}:

buildPythonPackage rec {
  pname = "tidyexc";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BkcviJSigvlE5qECxfbFpYu2gVidWLvheVw5BWOVgb4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/kalekundert/tidyexc/commit/73d0130cf4886b63a2b43aa4046e3fc95428ae48.patch";
      hash = "sha256-Lz/yYfipGQswwhXS+XNFzPKjyddn2vJ6bUZRQIxHhUM=";
    })
  ];

  nativeBuildInputs = [ flit-core_3 ];

  pythonImportsCheck = [ "tidyexc" ];

  meta = {
    description = "Raise rich, helpful exceptions";
    homepage = "https://github.com/kalekundert/tidyexc";
    changelog = "https://github.com/kalekundert/tidyexc/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
