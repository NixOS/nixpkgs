{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, flit-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tidyexc";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gl1jmihafawg7hvnn4xb20vd2x5qpvca0m1wr2gk0m2jj42yiq6";
  };

  patches = [
    # https://github.com/kalekundert/tidyexc/pull/5
    (fetchpatch {
      name = "replace-flit-with-flit-core.patch";
      url = "https://github.com/kalekundert/tidyexc/commit/73d0130cf4886b63a2b43aa4046e3fc95428ae48.patch";
      hash = "sha256-Lz/yYfipGQswwhXS+XNFzPKjyddn2vJ6bUZRQIxHhUM=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  pythonImportsCheck = [
    "tidyexc"
  ];

  meta = with lib; {
    description = "Raise rich, helpful exceptions";
    homepage = "https://github.com/kalekundert/tidyexc";
    changelog = "https://github.com/kalekundert/tidyexc/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
