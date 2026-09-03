{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  nix-update-script,
  pycryptodome,
  pyprojectVersionPatchHook,
  rustc,
  rustPlatform,
  stream-inflate,
  trio,
}:

buildPythonPackage (finalAttrs: {
  pname = "stream-unzip";
  version = "0.0.101";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uktrade";
    repo = "stream-unzip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JTMJdc61wR2nqYq3BMkLgi+krKsDUKBAgzbqlvYx8L0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-CKtu4ERN0L7XoZxFAQhgZSymLqGkBdP0eSy9DhFPwZk=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    pycryptodome
    stream-inflate
  ];

  optional-dependencies = {
    ci = [
      pycryptodome
      stream-inflate
    ];
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "stream_unzip" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python function to stream unzip all the files in a ZIP archive on the fly";
    homepage = "https://github.com/uktrade/stream-unzip";
    changelog = "https://github.com/uktrade/stream-unzip/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
