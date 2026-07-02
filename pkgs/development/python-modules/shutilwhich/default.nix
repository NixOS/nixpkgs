{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "shutilwhich";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbr";
    repo = "shutilwhich";
    rev = version;
    sha256 = "05fwcjn86w8wprck04iv1zccfi39skdf0lhwpb4b9gpvklyc9mj0";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest -rs
  '';

  meta = {
    description = "Backport of shutil.which";
    license = lib.licenses.psfl;
    homepage = "https://github.com/mbr/shutilwhich";
    maintainers = with lib.maintainers; [ multun ];
  };
}
