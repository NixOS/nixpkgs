{ lib
, python3Packages
, fetchFromGitHub
, fetchpatch
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-openwakeword";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-openwakeword";
    rev = "refs/tags/v${version}";
    hash = "sha256-N/EjdNQLsYLpJ4kOxY/z+/dMMmF1PPAIEEzSHfnZWaM=";
  };

  patches = [
    (fetchpatch {
      # import tflite entrypoint from tensorflow
      url = "https://github.com/rhasspy/wyoming-openwakeword/commit/8f4ba2750d8c545e77549a7230cdee1301dac09a.patch";
      hash = "sha256-WPvywpGv0sYYVGc7he4bt7APIsa3ziKaWqpFlx3v+V8=";
    })
    (fetchpatch {
      # add commandline entrypoint
      url = "https://github.com/rhasspy/wyoming-openwakeword/commit/f40e5635543b2315217538dd89a9fe40fe817cfe.patch";
      hash = "sha256-HNlGqt7bMzwyvhx5Hw7mkTHeQmBpgDCU3pUbZzss1bY=";
    })
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    tensorflow
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_openwakeword"
  ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming-openwakeword/blob/v${version}/CHANGELOG.md";
    description = "An open source voice assistant toolkit for many human languages";
    homepage = "https://github.com/rhasspy/wyoming-openwakeword";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "wyoming-openwakeword";
  };
}
