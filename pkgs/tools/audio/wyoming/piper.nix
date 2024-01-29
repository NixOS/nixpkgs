{ lib
, python3Packages
, fetchFromGitHub
, fetchpatch
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-piper";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-piper";
    # https://github.com/rhasspy/wyoming-piper/issues/3
    rev = "560927437c72eca4d334ca503d15863f0b42980d";
    hash = "sha256-Q4S96zs856zXVAGo4mB466an60naHiS2S/qxYxPE4sI=";
  };

  patches = [
    (fetchpatch {
      # add console script
      url = "https://github.com/rhasspy/wyoming-piper/commit/4c27fbd067fd543adede4626fc5868a3f2458734.patch";
      hash = "sha256-YPjDjeY9RLsgCtbBZoNgPyQTv3rbCJGcqTNSSwiqqEE=";
    })
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "wyoming"
  ];

  propagatedBuildInputs = with python3Packages; [
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_piper"
  ];

  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming-openwakeword/v${version}/master/CHANGELOG.md";
    description = "Wyoming Server for Piper";
    homepage = "https://github.com/rhasspy/wyoming-openwakeword";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
