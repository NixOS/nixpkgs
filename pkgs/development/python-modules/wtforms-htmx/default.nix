{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  wtforms_3_3,
  nix-update-script,
  pytestCheckHook,
  pytest-xdist,
  flask,
}:

let
  wtforms = wtforms_3_3;
in
buildPythonPackage (finalAttrs: {
  pname = "wtforms-htmx";
  version = "0.1.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yaal-coop";
    repo = "wtforms-htmx";
    tag = finalAttrs.version;
    hash = "sha256-c5xgkMHDoP61MhfStBHqBAyi4W6AKy31in2RHK8LeXQ=";
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    flask
  ];

  pythonImportsCheck = [
    "wtforms_htmx"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive WTForms forms with no hand-written JavaScript, powered by htmx and dark magic";
    homepage = "https://github.com/yaal-coop/wtforms-htmx";
    changelog = "https://github.com/yaal-coop/wtforms-htmx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
