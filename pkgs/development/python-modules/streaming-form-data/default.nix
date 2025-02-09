{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder,
cython, smart-open, pytestCheckHook, moto, requests-toolbelt }:

buildPythonPackage rec {
  pname = "streaming-form-data";
  version = "1.13.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "siddhantgoel";
    repo = "streaming-form-data";
    rev = "v${version}";
    hash = "sha256-Ntiad5GZtfRd+2uDPgbDzLBzErGFroffK6ZAmMcsfXA=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ smart-open ];

  nativeCheckInputs = [ pytestCheckHook moto requests-toolbelt ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "streaming_form_data" ];

  preCheck = ''
    # remove in-tree copy to make pytest find the installed one, with the native parts already built
    rm -rf streaming_form_data
  '';

  meta = with lib; {
    description = "Streaming parser for multipart/form-data";
    homepage = "https://github.com/siddhantgoel/streaming-form-data";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
