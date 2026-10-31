{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  nix-update-script,
}:

# gen/python is symforce's own pre-generated numerical Python package
# (checked into the symforce-org/symforce monorepo, not built fresh by
# consumers), declared as a separate "symforce-sym" distribution that the
# main symforce package depends on - packaged from the exact same pinned
# tag symforce itself uses, so the two never drift apart.
buildPythonPackage rec {
  pname = "symforce-sym";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symforce-org";
    repo = "symforce";
    tag = "v${version}";
    hash = "sha256-mEIszv14bHY/kCafIcXmG1h4sXQXTwVf5HhObDtm/SI=";
  };

  sourceRoot = "${src.name}/gen/python";

  # setuptools_scm's `root = "../.."` (relative to this subdirectory) expects
  # the whole symforce checkout, which we didn't fetch here.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ numpy ];

  # Bump in lockstep with python3Packages.symforce's own version - both are
  # built from the same tag.
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generated numerical Python package installed by SymForce";
    homepage = "https://github.com/symforce-org/symforce/tree/main/gen/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
