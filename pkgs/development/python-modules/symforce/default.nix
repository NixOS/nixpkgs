{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  git,
  cmake,
  pip,
  setuptools-scm,
  argh,
  eigen,
  catch2_3,
}:

# TODO: This is WIP
# TODO: Unvendor dependencies from third_party
buildPythonPackage rec {
  pname = "symforce";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symforce-org";
    repo = "symforce";
    tag = "v${version}";
    hash = "sha256-WrOwEUJHk+xOAfccHY2D5pCMg44KJJMvWHAJ90DuOQo=";
  };

  # A band-aid fix for their band-aid fix
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "FATAL_ERROR" "WARNING"
  '';

  build-system = [
    setuptools
    cmake
    pip
    setuptools-scm
    git # TODO: Upstream patch that also catches FileNotFoundError when git not installed
  ];
  dependencies = [
    argh
    eigen
    catch2_3
  ];

  meta = {
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
