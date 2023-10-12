{ lib
, python3
, python3Packages
, fetchFromGitHub
, fetchpatch
}:

python3.pkgs.buildPythonApplication {
  pname = "wyoming-openwakeword";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "rhasspy3";
    rev = "e16d7d374a64f671db48142c7b635b327660ebcf";
    hash = "sha256-SbWsRmR1hfuU3yJbuu+r7M43ugHeNwLgu5S8MqkbCQA=";
  };

  patches = [
    (fetchpatch {
      # import tflite entrypoint from tensorflow
      url = "https://github.com/rhasspy/rhasspy3/commit/23b1bc9cf1e9aa78453feb11e27d5dafe26de068.patch";
      hash = "sha256-fjLJ+VI4c8ABBWx1IjZ6nS8MGqdry4rgcThKiaAvz+Q=";
    })
    (fetchpatch {
      # add commandline entrypoint
      url = "https://github.com/rhasspy/rhasspy3/commit/7662b82cd85e16817a3c6f4153e855bf57436ac3.patch";
      hash = "sha256-41CLkVDSAJJpZ5irwIf/Z4wHoCuKDrqFBAjKCx7ta50=";
    })
  ];

  postPatch = ''
    cd programs/wake/openwakeword-lite/server
  '';

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    tensorflow-bin
    webrtc-noise-gain
    wyoming
  ];

  passthru.optional-dependencies.webrtc = with python3Packages; [
    webrtc-noise-gain
  ];

  pythonImportsCheck = [
    "wyoming_openwakeword"
  ];

  meta = with lib; {
    description = "An open source voice assistant toolkit for many human languages";
    homepage = "https://github.com/rhasspy/rhasspy3/commit/fe44635132079db74d0c76c6b3553b842aa1e318";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "wyoming-openwakeword";
  };
}
