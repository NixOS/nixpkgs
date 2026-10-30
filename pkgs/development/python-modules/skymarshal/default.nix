{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  argh,
  jinja2,
  numpy,
  ply,
}:

# Vendored inside symforce-org/symforce as third_party/skymarshal (a fork of
# LCM's skymarshal, used by symforce's own build as a setup_requires-style
# build dependency) rather than a project with its own release cadence;
# packaged from the exact same pinned tag symforce itself uses, so the two
# never drift apart.
buildPythonPackage rec {
  pname = "skymarshal";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symforce-org";
    repo = "symforce";
    tag = "v${version}";
    hash = "sha256-mEIszv14bHY/kCafIcXmG1h4sXQXTwVf5HhObDtm/SI=";
  };

  sourceRoot = "${src.name}/third_party/skymarshal";

  # setuptools_scm's `root = "../.."` (relative to this subdirectory) expects
  # the whole symforce checkout, which we didn't fetch here.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    argh
    jinja2
    numpy
    ply
  ];

  meta = {
    description = "Python implementation of marshalling for LCM messages (symforce's vendored fork)";
    homepage = "https://github.com/symforce-org/symforce/tree/main/third_party/skymarshal";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
