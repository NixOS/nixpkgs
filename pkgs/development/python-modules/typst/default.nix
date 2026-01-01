{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "typst";
<<<<<<< HEAD
  version = "0.14.5";
=======
  version = "0.14.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "messense";
    repo = "typst-py";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Slo9cstmh9ZjxcqVdRldU+n82JK1cGf89cHE9Rrh7z0=";
=======
    hash = "sha256-PshpYyT+WVZezHEMYETsxwSlPzZ8mXWFw2YgXPEyAIw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-haEthOKjyQkHhPgYPo40uLjfv29BDCC084KWmGRwkVk=";
=======
    hash = "sha256-453c6hs1Wr4KFu523jMqdNmi0cBxlpkh92bt4ZXXhLo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [ openssl ];

  pythonImportsCheck = [ "typst" ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Python binding to typst";
    homepage = "https://github.com/messense/typst-py";
    changelog = "https://github.com/messense/typst-py/releases/tag/v${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
