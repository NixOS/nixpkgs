{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sumtypes";
  version = "0.1a6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "radix";
    repo = "sumtypes";
    rev = version;
    hash = "sha256-qwQyFKVnGEqHUqFmUSnHVvedsp2peM6rJZcS90paLOo=";
  };

  propagatedBuildInputs = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Algebraic data types for Python";
    homepage = "https://github.com/radix/sumtypes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NieDzejkob ];
  };
}
