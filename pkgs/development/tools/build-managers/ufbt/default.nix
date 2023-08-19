{ lib
, buildPythonApplication
, fetchFromGitHub
, setuptools
}:

buildPythonApplication rec {
  pname = "ufbt";
  version = "0.2.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "flipperdevices";
    repo = "flipperzero-ufbt";
    rev = "v${version}";
    hash = "sha256-gnSuwCRj8PFCuhEUP/B4YIjcLlY29527WWmjQQw7RkQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    description = "Compact tool for building and debugging applications for Flipper Zero";
    homepage = "https://github.com/flipperdevices/flipperzero-ufbt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ emilytrau ];
  };
}
