{ lib, buildPythonPackage, fetchPypi, setuptools-scm, zopfli, pytest }:

buildPythonPackage rec {
  pname = "zopfli";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-x9PzVcSR84TkNNsuYmheq269pmuWTonhdUuxFLLTjOo=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ zopfli ];
  USE_SYSTEM_ZOPFLI = "True";

  # doesn't work with pytestCheckHook
  checkInputs = [ pytest ];

  meta = with lib; {
    description = "cPython bindings for zopfli";
    homepage = "https://github.com/obp/py-zopfli";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
