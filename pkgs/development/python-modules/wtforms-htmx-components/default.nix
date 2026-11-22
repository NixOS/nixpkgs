{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  wtforms_3_3,
  wtforms-htmx,
  pytestCheckHook,
  flask,
  nix-update-script,
}:

let
  wtforms = wtforms_3_3;
in
buildPythonPackage (finalAttrs: {
  pname = "wtforms-htmx-components";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yaal-coop";
    repo = "wtforms-htmx-components";
    tag = finalAttrs.version;
    hash = "sha256-1bPQpG8AFP5yNKubFNAHw+Y4kDxpPjFVZ+mA4XJyucc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.13.1,<0.14' 'uv_build'
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    wtforms
    wtforms-htmx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    flask
  ];

  pythonImportsCheck = [
    "wtforms_htmx_components"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ready-made interactive WTForms fields built on wtforms-htmx";
    homepage = "https://github.com/yaal-coop/wtforms-htmx-components";
    changelog = "https://github.com/yaal-coop/wtforms-htmx-components/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
