{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  hatchling,
  onnxruntime,
  torch,
  torchaudio,
}:
buildPythonPackage rec {
  pname = "silero-vad";
  version = "5.1.2";
  src = fetchFromGitHub {
    owner = "snakers4";
    repo = "silero-vad";
    tag = "v${version}";
    hash = "sha256-XdETFa2nZyze3KtnGyPJXbRNHy0aFRBsKDzcWxaUYlo=";
  };

  pyproject = true;

  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    hatchling
    onnxruntime
    torch
    torchaudio
  ];

  # onnxruntime may fail to start in sandbox, disable check if onnxruntime does too
  pythonImportsCheck = lib.optionals onnxruntime.doCheck [ "silero_vad" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Pre-trained enterprise-grade Voice Activity Detector";
    homepage = "https://github.com/snakers4/silero-vad";
    license = with lib.licenses; [ mit ];
  };
}
