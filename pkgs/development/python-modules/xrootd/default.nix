{
  lib,
  buildPythonPackage,
  cmake,
  setuptools,
  xrootd,
}:

buildPythonPackage rec {
  pname = "xrootd";
  pyproject = true;

  inherit (xrootd) version src;

  sourceRoot = "${src.name}/python";

  # The VERSION file exported from the upstream git repository contains an
  # unexpanded `$Format:%(describe)$` placeholder, and there is no git
  # repository available to `git describe`, so upstream's `get_version()`
  # would fall back to a `5.9-rc<date>` development version and fail the
  # pythonMetadataCheckPhase. Write the actual version instead.
  postPatch = ''
    rm VERSION
    echo -n "${xrootd.version}" > VERSION
  '';

  env.CMAKE_ARGS = lib.toString [
    (lib.cmakeFeature "XRootD_INCLUDE_DIR" "${lib.getDev xrootd}/include/xrootd;${src}/src")
  ];

  build-system = [
    cmake
    setuptools
  ];

  buildInputs = [ xrootd ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "XRootD" ];

  # Tests are only compatible with Python 2
  doCheck = false;

  meta = {
    description = "XRootD central repository";
    homepage = "https://github.com/xrootd/xrootd";
    changelog = "https://github.com/xrootd/xrootd/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
