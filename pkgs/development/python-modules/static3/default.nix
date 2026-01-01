{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # optionals
  genshi,

  # tests
  pytestCheckHook,
  webtest,
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

  optional-dependencies = {
    KidMagic = [
      # TODO: kid
    ];
    Genshimagic = [ genshi ];
  };

  pythonImportsCheck = [ "static" ];

  nativeCheckInputs = [
    pytestCheckHook
    webtest
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;

  meta = {
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/rmohr/static3/releases/tag/v${version}";
    description = "Really simple WSGI way to serve static (or mixed) content";
    mainProgram = "static";
    homepage = "https://github.com/rmohr/static3";
<<<<<<< HEAD
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ hexa ];
=======
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
