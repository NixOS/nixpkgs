{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "xdoctest";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Erotemic";
    repo = "xdoctest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cwRelkADUrSbrzJ8JjgLCiPil2ynwFmaLLWByJWkXwA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "xdoctest" ];

  meta = {
    description = "Rewrite of Python's builtin doctest module (with pytest plugin integration) with AST instead of REGEX";
    homepage = "https://github.com/Erotemic/xdoctest";
    changelog = "https://github.com/Erotemic/xdoctest/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "xdoctest";
  };
})
