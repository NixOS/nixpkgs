{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

let
  pname = "translitcodec";
  version = "0.7.0";
in
buildPythonPackage {
  inherit pname version;

  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "claudep";
    repo = "translitcodec";
    rev = "version-${version}";
    hash = "sha256-/EKquTchx9i3fZqJ6AMzHYP9yCORvwbuUQ95WJQOQbI=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    description = "Unicode to 8-bit charset transliteration codec";
    homepage = "https://github.com/claudep/translitcodec";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rycee ];
  };
}
