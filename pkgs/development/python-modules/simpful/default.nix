{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, pytestCheckHook
, pythonOlder
, scipy
, seaborn
, requests
}:

buildPythonPackage rec {
  pname = "simpful";
  version = "2.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aresio";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vT7Y/6bD+txEVEw/zelMogQ0V7BIHHRitrC1COByzhY=";
  };

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
  };
}
