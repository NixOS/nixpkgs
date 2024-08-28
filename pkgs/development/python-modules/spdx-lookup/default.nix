{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  nix-update-script,
  setuptools,
  spdx,
}:

buildPythonPackage rec {
  pname = "spdx-lookup";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = "spdx-lookup-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-jtzhqRAj1BWdU8AuR7Gr343mL5alLXhi+SyCkCI5AAU=";
  };

  build-system = [ setuptools ];

  dependencies = [ spdx ];

  pythonImportsCheck = [ "spdx_lookup" ];

  # upstream has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SPDX license list query tool";
    homepage = "https://github.com/bbqsrc/spdx-lookup-python";
    changelog = "https://github.com/bbqsrc/spdx-lookup-python/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
