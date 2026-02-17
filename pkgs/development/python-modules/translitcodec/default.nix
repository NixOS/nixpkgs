{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

let
  pname = "translitcodec";
  version = "0.7.0";
in
buildPythonPackage {
  inherit pname version;

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "claudep";
    repo = "translitcodec";
    rev = "version-${version}";
    hash = "sha256-/EKquTchx9i3fZqJ6AMzHYP9yCORvwbuUQ95WJQOQbI=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ pname ];

  meta = {
    description = "Unicode to 8-bit charset transliteration codec";
    homepage = "https://github.com/claudep/translitcodec";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ rycee ];
  };
}
