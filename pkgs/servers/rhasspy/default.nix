{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rhasspy";
  version = "unstable-2023-03-29";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "rhasspy3";
    rev = "f11b15fdfb29fb2f8274dae83db5909558012d1f";
    hash = "sha256-BQ9efrFyjXEa8yxGaEal4+KnxbQRfwSZbdwogI1RPuw=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    hypercorn
    quart
    quart-cors
  ];

  pythonImportsCheck = [
    "rhasspy3"
    "rhasspy3_http_api"
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "An open source voice assistant toolkit for many human languages";
    homepage = "https://github.com/rhasspy/rhasspy3";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
