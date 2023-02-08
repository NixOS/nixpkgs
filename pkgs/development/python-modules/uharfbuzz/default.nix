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
  version = "0.24.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  # Fetching from GitHub as Pypi contains different versions
  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    rev = "v${version}";
    sha256 = "sha256-DyFXbwB28JH2lvmWDezRh49tjCvleviUNSE5LHG3kUg=";
    fetchSubmodules = true;
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
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
