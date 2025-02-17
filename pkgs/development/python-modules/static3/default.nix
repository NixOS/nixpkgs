{ lib
, buildPythonPackage
, fetchFromGitHub

# optionals
, genshi

# tests
, pytestCheckHook
, webtest
}:

buildPythonPackage rec {
  pname = "static3";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rmohr";
    repo = "static3";
    rev = "v${version}";
    hash = "sha256-uFgv+57/UZs4KoOdkFxbvTEDQrJbb0iYJ5JoWWN4yFY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'pytest-cov'" ""
  '';

  passthru.optional-dependencies = {
    KidMagic = [
      # TODO: kid
    ];
    Genshimagic = [
      genshi
    ];
  };

  pythonImportsCheck = [
    "static"
  ];

  nativeCheckInputs  = [
    pytestCheckHook
    webtest
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/rmohr/static3/releases/tag/v${version}";
    description = "A really simple WSGI way to serve static (or mixed) content";
    homepage = "https://github.com/rmohr/static3";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ hexa ];
  };
}
