{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

let
  pname = "translitcodec";
  version = "0.7.0";
in
buildPythonPackage {
  inherit pname version;

  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "claudep";
    repo = "translitcodec";
    tag = "version-${version}";
    hash = "sha256-/EKquTchx9i3fZqJ6AMzHYP9yCORvwbuUQ95WJQOQbI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ pname ];

  meta = {
    description = "Unicode to 8-bit charset transliteration codec";
    homepage = "https://github.com/claudep/translitcodec";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rycee ];
  };
}
