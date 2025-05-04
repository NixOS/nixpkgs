{ lib
, stdenv
, fetchFromGitHub
, python3
, buildPythonApplication
, magika
, ffmpeg ? null
}:

buildPythonApplication rec {
  pname = "markitdown";
  version = "0.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "markitdown";
    rev = "c1f9a323ee43782ab014032ce8731f5de6eb87ed";  # v0.1.1
    hash = "sha256-siXam2a+ryyLBbciQgjd9k6zC8r46LbzjPMoc1dG0wk=";
  };

  sourceRoot = "${src.name}/packages/markitdown";

  nativeBuildInputs = with python3.pkgs; [
    hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    # Core dependencies
    beautifulsoup4
    requests
    markdownify
    charset-normalizer
  ] ++ [
    # Custom dependencies
    magika

    # Optional dependencies (all features)
    python-pptx
    mammoth
    pandas
    openpyxl
    xlrd
    lxml
    pdfminer-six
    olefile
    pydub
    speechrecognition
    youtube-transcript-api
    azure-ai-documentintelligence
    azure-identity
  ];

  # Add ffmpeg for audio transcription if provided
  buildInputs = lib.optionals (ffmpeg != null) [
    ffmpeg
  ];

  # Make sure ffmpeg is in the PATH for pydub
  makeWrapperArgs = lib.optionals (ffmpeg != null) [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  pythonImportsCheck = [ "markitdown" ];

  meta = with lib; {
    description = "Lightweight Python utility for converting various files to Markdown";
    homepage = "https://github.com/microsoft/markitdown";
    license = licenses.mit;
    maintainers = with maintainers; [ ];  # Add your GitHub username here when submitting to nixpkgs
    platforms = platforms.unix;
  };
}