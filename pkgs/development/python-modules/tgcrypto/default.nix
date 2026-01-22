{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tgcrypto";
  version = "1.2.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "tgcrypto";
    tag = "v${version}";
    hash = "sha256-u+mXzkmM79NBi4oHnb32RbN9WPnba/cm1q2Ko0uNEZg=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tgcrypto" ];

  meta = {
    description = "Fast and Portable Telegram Crypto Library for Python";
    homepage = "https://github.com/pyrogram/tgcrypto";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
