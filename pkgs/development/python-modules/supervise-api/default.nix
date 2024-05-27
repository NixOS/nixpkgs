{
  lib,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  supervise,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "supervise-api";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "supervise_api";
    inherit version;
    hash = "sha256-EjD0IpSRDoNCG307CKlo0n1RCkpwnpZlB+1w212hud4=";
  };

  postPatch = ''
    substituteInPlace supervise_api/supervise.py \
      --replace 'which("supervise")' '"${supervise}/bin/supervise"'
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "supervise_api" ];

  meta = {
    description = "An API for running processes safely and securely";
    homepage = "https://github.com/catern/supervise";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ catern ];
  };
}
