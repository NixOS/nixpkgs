{ lib
, stdenv
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
  version = "2.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aresio";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1CU/Iz83CKRx7dsOTGfdJm98TUfc2kxCHKIEUXP36HQ=";
  };

  # patch dated use of private matplotlib interface
  # https://github.com/aresio/simpful/issues/22
  postPatch = ''
    substituteInPlace simpful/simpful.py \
      --replace \
        "next(ax._get_lines.prop_cycler)['color']" \
        "ax._get_lines.get_next_color()"
  '';

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
    broken = stdenv.isDarwin;
    description = "Library for fuzzy logic";
    homepage = "https://github.com/aresio/simpful";
    changelog = "https://github.com/aresio/simpful/releases/tag/${version}";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
