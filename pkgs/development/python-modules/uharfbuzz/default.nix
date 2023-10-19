{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cython
, setuptools-scm
, pytestCheckHook
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "uharfbuzz";
  version = "0.37.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-CZp+/5fG5IBawnIZLeO9lXke8rodqRcSf+ofyF584mc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    cython
    setuptools-scm
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ ApplicationServices ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "uharfbuzz" ];

  meta = with lib; {
    description = "Streamlined Cython bindings for the harfbuzz shaping engine";
    homepage = "https://github.com/harfbuzz/uharfbuzz";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
