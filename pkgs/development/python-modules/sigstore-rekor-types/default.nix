{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sigstore-rekor-types";
  version = "0.0.18";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "sigstore-rekor-types";
    tag = "v${version}";
    hash = "sha256-vOGKDWhOg8dsgxyxOtM+czR+NOM26v0T0ctkFPUAYEo=";
  };

  build-system = [ setuptools ];

  dependencies = [ pydantic ] ++ pydantic.optional-dependencies.email;

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Python models for Rekor's API types";
    homepage = "https://github.com/trailofbits/sigstore-rekor-types";
    changelog = "https://github.com/trailofbits/sigstore-rekor-types/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      bot-wxt1221
    ];
  };
}
