{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder,
cython, numpy, pytest, requests-toolbelt }:

buildPythonPackage rec {
  pname = "streaming-form-data";
  version = "1.8.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "siddhantgoel";
    repo = "streaming-form-data";
    rev = "v${version}";
    sha256 = "1wnak8gwkc42ihgf0g9r7r858hxbqav2xdgqa8azid8v2ff6iq4d";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ requests-toolbelt ];

  nativeCheckInputs = [ numpy pytest ];

  checkPhase = ''
    make test
  '';

  pythonImportsCheck = [ "streaming_form_data" ];

  meta = with lib; {
    description = "Streaming parser for multipart/form-data";
    homepage = "https://github.com/siddhantgoel/streaming-form-data";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
