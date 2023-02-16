{ lib
, fetchFromGitHub
, python3Packages
, qt6
}:

python3Packages.buildPythonApplication rec {
  pname = "khoj";
  version = "0.2.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "debanjum";
    repo = "khoj";
    rev = "refs/tags/${version}";
    hash = "sha256-QcxP+USj7vlLKPno2mV53nFonZM38VzL8D4zY6d8y3k=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiofiles
    dateparser
    defusedxml
    fastapi
    huggingface-hub
    jinja2
    numpy
    openai
    pillow
    pydantic
    pyqt6
    pyyaml
    schedule
    sentence-transformers
    torch
    torchvision
    transformers
    uvicorn
  ];

  buildInputs = with qt6; [
    qtwayland
  ];

  nativeBuildInputs = with qt6; [
    wrapQtAppsHook
  ];

  checkInputs = with python3Packages; [
    pytest
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aiofiles == 0.8.0" "aiofiles >= 0.8.0" \
      --replace "openai == 0.20.0" "openai >= 0.20.0" \
      --replace "pytest == 7.1.2" "pytest >= 7.1.2" \
      --replace "fastapi == 0.77.1" "fastapi >= 0.77.1" \
      --replace "numpy == 1.22.4" "numpy >= 1.22.4" \
      --replace "huggingface_hub == 0.8.1" "huggingface_hub >= 0.8.1" \
      --replace "dateparser == 1.1.1" "dateparser >= 1.1.1" \
      --replace "sentence-transformers == 2.1.0" "sentence-transformers >= 2.1.0" \
      --replace "transformers == 4.21.0" "transformers >= 4.21.0" \
      --replace "torchvision == 0.14.1" "torchvision" \
      --replace "pydantic == 1.9.1" "pydantic >= 1.9.1" \
      --replace "pyqt6 == 6.3.1" "pyqt6 >= 6.3.1" \
      --replace "uvicorn == 0.17.6" "uvicorn >= 0.17.6"
  '';

  meta = with lib; {
    description = "Natural Language Search Assistant for your Org-Mode and Markdown notes, Beancount transactions and Photos";
    homepage = "https://github.com/debanjum/khoj";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
