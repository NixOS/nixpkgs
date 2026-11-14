{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  versionCheckHook,
  hatchling,
  cryptography,
  jsonschema,
  pyparsing,
  pyyaml,
  typer,
  zip,
}:

buildPythonPackage (finalAttrs: {
  pname = "swi-tools";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "swi-tools";
    # master branch is at 1.6, they don't have a v1.6 branch/tag
    rev = "6db86f5983426d272e541a61e0add79b3fec5b1e";
    hash = "sha256-enWxDrTFWxJCwHF8NjH2UvZ/cxJnldF5nxm+Xzmu4xY=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    cryptography
    jsonschema
    pyparsing
    pyyaml
    typer
    zip
  ];

  # verify.py uses importlib.resources.files(__name__) but __name__ is
  # "switools.verify" (a module, not a package).  The cert lives in the
  # "switools" package directory, so we need to reference that instead.
  postPatch = ''
    substituteInPlace src/switools/verify.py \
      --replace-fail 'import importlib' 'import importlib, importlib.resources' \
      --replace-fail 'importlib.resources.files(__name__)' 'importlib.resources.files("switools")'
  '';

  # Importing verify triggers the importlib.resources cert load,
  # so this catches the exact bug we patched above.
  pythonImportsCheck = [
    "switools"
    "switools.verify"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    zip
    versionCheckHook
  ];

  meta = {
    description = "Scripts for operating on an Arista SWI or SWIX";
    homepage = "https://github.com/aristanetworks/swi-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "swi-tools";
  };
})
