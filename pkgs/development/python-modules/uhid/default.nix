{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage {
  pname = "uhid";
  version = "0-unstable-2021-04-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FFY00";
    repo = "python-uhid";
    rev = "99f459aef3934a146d1954ae372b1a107b1f34eb";
    hash = "sha256-QTTlSYaDciWc9I/MUvR9YJ9z4oxHeN/PLJ3rcJhRd/w=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "uhid" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Pure Python typed Linux UHID wrapper";
    homepage = "https://github.com/FFY00/python-uhid";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
