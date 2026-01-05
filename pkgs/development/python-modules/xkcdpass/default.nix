{
  lib,
  buildPythonPackage,
  fetchPypi,
  installShellFiles,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.20.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tav9fStZzdpZ+Tf7IiEKxGSa0NLgnh+Hv+dKVOI60Yo=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xkcdpass" ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/redacted/XKCD-password-generator/issues/138
    "test_entropy_printout_valid_input"
  ];

  postInstall = ''
    installManPage *.?
    install -Dm444 -t $out/share/doc/${pname} README*
  '';

  meta = {
    description = "Generate secure multiword passwords/passphrases, inspired by XKCD";
    homepage = "https://github.com/redacted/XKCD-password-generator";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "xkcdpass";
  };
}
