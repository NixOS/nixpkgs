{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, pytestCheckHook
, pythonOlder
, requests
, scipy
, seaborn
, setuptools
}:

buildPythonPackage rec {
  pname = "simpful";
  version = "2.11.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aresio";
    repo = "simpful";
    rev = "refs/tags/${version}";
    hash = "sha256-54WkKnPB3xA2CaOpmasqxgDoga3uAqoC1nOivytXmGY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    requests
  ];

  passthru.optional-dependencies = {
    plotting = [
      matplotlib
      seaborn
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "simpful"
  ];

  meta = with lib; {
    description = "Library for fuzzy logic";
    homepage = "https://github.com/aresio/simpful";
    changelog = "https://github.com/aresio/simpful/releases/tag/${version}";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ fab ];
    broken = stdenv.isDarwin;
  };
}
