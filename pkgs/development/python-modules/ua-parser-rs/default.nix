{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  pytestCheckHook,
  pyyaml,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "ua-parser-rs";
<<<<<<< HEAD
  version = "0.1.4";
=======
  version = "0.1.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-rust";
    tag = "ua-parser-rs-${version}";
<<<<<<< HEAD
    hash = "sha256-8IU4NNW0v2zl6COtL6o7FALxqYNVKBGhERugxpXIN5g=";
=======
    hash = "sha256-Tro3aPjqDN/9c3wBUDDafDpdYXhHEAHeP8NwoU9a4u0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-PNkyd9/0DdIqEmXbnw3dZs5ajWSo0rLhjJwRu3H06Cc=";
=======
    hash = "sha256-NZpMW8cFXXpkSP8jMcXMiDyfyIuhR5C0TUzBsJVkOEE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildAndTestSubdir = "ua-parser-py";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "ua-parser-rs-"; };

  meta = {
    description = "Native accelerator for ua-parser";
    homepage = "https://github.com/ua-parser/uap-rust/tree/main/ua-parser-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
