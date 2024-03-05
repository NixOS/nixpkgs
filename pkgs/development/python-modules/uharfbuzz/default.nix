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
  version = "0.37.3";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-876gFYyMqeGYoXMdBguV6bi7DJKHJs9HNLw9xRu+Mxk=";
  };

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
