{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "xdg-base-dirs";
  version = "6.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "srstevenson";
    repo = "xdg-base-dirs";
    tag = finalAttrs.version;
    hash = "sha256-iXK9WURTfmpl5vd7RsT0ptwfrb5UQQFqMMCu3+vL+EY=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xdg_base_dirs" ];

  # remove coverage flags from pytest config
  postPatch = ''
    sed -i /addopts/d pyproject.toml
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the XDG Base Directory Specification in Python";
    homepage = "https://github.com/srstevenson/xdg-base-dirs";
    changelog = "https://github.com/srstevenson/xdg-base-dirs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
})
