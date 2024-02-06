{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, runCommand
, ffmpeg
, ffmpeg-python
, httpx
, librosa
, norbert
, numpy
, pandas
, poetry-core
, pytest-forked
, pytestCheckHook
, tensorflow
, typer
}:

buildPythonPackage rec {
  pname = "spleeter";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "deezer";
    repo = pname;
    # release not tagged: this is the revision that bumps the version in pyproject.toml
    rev = "72e62a7770c8c1bfec674741f578d8ca5eb3a09b";
    sha256 = "1zsdz3x1zrlrb4bhzf1i5d29l9y4a4pax7f53qz2a1p9cb9cvg92";
  };
  format = "pyproject";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'ffmpeg-python = "0.2.0"' 'ffmpeg-python = "*"' \
      --replace 'httpx = {extras = ["http2"], version = "^0.16.1"}' 'httpx = "*"' \
      --replace 'librosa = "0.8.0"' 'librosa = "*"' \
      --replace 'norbert = "0.2.1"' 'norbert = "*"' \
      --replace 'numpy = "<1.19.0,>=1.16.0"' 'numpy = "*"' \
      --replace 'pandas = "1.1.2"' 'pandas = "*"' \
      --replace 'tensorflow = "2.3.0"' 'tensorflow = "*"' \
      --replace 'typer = "^0.3.2"' 'typer = "*"' \
      --replace 'python = ">=3.6.1,<3.9"' 'python = "*"'
  '';
  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [
    ffmpeg-python
    httpx
    librosa
    norbert
    numpy
    pandas
    tensorflow
    typer
  ];

  checkInputs = [ pytestCheckHook pytest-forked ffmpeg ];
  preCheck = let
    model2Stems = fetchurl {
      url = "https://github.com/deezer/spleeter/releases/download/v1.4.0/2stems.tar.gz";
      sha256 = "14nn5cakj2n8xxc3j7y692w9gy2xfj38m905ifg2cx18vlwhpagk";
    };
    model2StemsUnpacked = runCommand "2stems" {} ''
      mkdir $out
      tar -C $out -zxf ${model2Stems}
    '';
  in ''
    export NUMBA_CACHE_DIR="$(mktemp -d)"
    rm -r spleeter/
    mkdir pretrained_models
    ln -s ${model2StemsUnpacked} pretrained_models/2stems
  '';
  pytestFlagsArray = [ "tests/" ];
  disabledTestPaths = [
    # we don't yet package musdb, required for this functionality
    "tests/test_eval.py"
    # requires network access
    "tests/test_github_model_provider.py"
  ];
  # only testing against 2stems to limit download size
  disabledTests = [ "4stems" "5stems" ];

  pythonImportsCheck = [ "spleeter" ];

  meta = {
    homepage = "https://github.com/deezer/spleeter";
    description = "Audio source separation library including pretrained models";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ris ];
  };
}
