{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xstatic-font-awesome";
  version = "6.2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xstatic-py";
    repo = "xstatic-font-awesome";
    tag = version;
    hash = "sha256-O70Io+9PCFDn+K9GqR/AeLSGzdRtu7cqn69dr4/QBSc=";
  };

  # xstatic uses pkg_resources.declare_namespace, removed in setuptools 83.
  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://github.com/xstatic-py/xstatic-font-awesome";
    description = "Font Awesome packaged for python";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ aither64 ];
  };
}
