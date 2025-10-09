{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pydantic,
  typing-extensions,
  uv-build,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sigstore-models";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "sigstore-models";
    tag = "v${version}";
    hash = "sha256-zlIZzfgHZPEuiZu3JNX74Cg1jPNaO1HUhMtpxoyOoqk=";
  };

  patches = [
    # https://github.com/astral-sh/sigstore-models/pull/4
    (fetchpatch2 {
      name = "uv-build.patch";
      url = "https://github.com/Prince213/sigstore-models/commit/0cbd46ce7ebc8a5d2825b8fc98147a9ba4b3be70.patch?full_index=1";
      hash = "sha256-6DLhhHkGW2Ok9xwKx6YT5BkCqQNH/Ja/KEO9FHl4NXo=";
    })
  ];

  build-system = [ uv-build ];

  dependencies = [
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigstore_models" ];

  meta = {
    description = "Pydantic-based, protobuf-free data models for Sigstore";
    homepage = "https://github.com/astral-sh/sigstore-models";
    changelog = "https://github.com/astral-sh/sigstore-models/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
