{ buildPythonPackage
, fetchFromGitHub
, lib
, nix-update-script
, pytestCheckHook
, git
, setuptools-scm
, writeScript
}:
buildPythonPackage rec {
  pname = "setuptools-odoo";
  version = "3.1.12";
  src = fetchFromGitHub {
    owner = "acsone";
    repo = pname;
    rev = version;
    hash = "sha256-GIX21gOENE0r3yFIyzwjaoEcb0XvuCqiPU8F3GLxNt4=";
  };

  propagatedBuildInputs = [
    setuptools-scm
  ];

  # HACK https://github.com/NixOS/nixpkgs/pull/229460
  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  patchPhase = ''
    runHook prePatch

    old_manifest="$(cat MANIFEST.in 2>/dev/null || true)"
    echo 'global-include **' > MANIFEST.in
    echo "$old_manifest" >> MANIFEST.in

    runHook postPatch
  '';

  pythonImportsCheck = [
    "setuptools_odoo"
  ];

  setupHook = writeScript "setupHook.sh" ''
    setuptoolsOdooHook() {
      # Don't look for a version suffix from git when building addons
      export SETUPTOOLS_ODOO_POST_VERSION_STRATEGY_OVERRIDE=none

      # Let setuptools-odoo know which files to install, when Git is missing
      # HACK https://github.com/acsone/setuptools-odoo/issues/20#issuecomment-340192355
      echo 'recursive-include odoo/addons/* **' >> MANIFEST.in

      # Make sure you can import the built addon
      for manifest in $(find -L . -name __manifest__.py); do
        export pythonImportsCheck="$pythonImportsCheck odoo.addons.$(basename $(dirname $manifest))"
      done
    }

    preBuildHooks+=(setuptoolsOdooHook)
  '';

  nativeCheckInputs = [ pytestCheckHook git ];
  disabledTests = [
    "test_addon1_uncommitted_change"
    "test_addon1"
    "test_addon2_uncommitted_version_change"
    "test_odoo_addon1_sdist"
    "test_odoo_addon1"
    "test_odoo_addon5_wheel"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Setuptools plugin for Odoo addons";
    homepage = "https://github.com/acsone/setuptools-odoo";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
