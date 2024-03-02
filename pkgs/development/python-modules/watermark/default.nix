{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, ipython
, py3nvml
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "watermark";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "watermark";
    rev = "refs/tags/v${version}";
    hash = "sha256-4/1Y7cdh1tF33jgPrqdxCGPcRnnxx+Wf8lyztF54Ck0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ipython
    importlib-metadata
  ];

  passthru.optional-dependencies = {
    gpu = [
      py3nvml
    ];
  };

  nativeCheckInputs =  [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "watermark"
  ];

  meta = with lib; {
    description = "IPython extension for printing date and timestamps, version numbers, and hardware information";
    homepage = "https://github.com/rasbt/watermark";
    changelog = "https://github.com/rasbt/watermark/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nphilou ];
  };
}
