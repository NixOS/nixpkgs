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
  ply,
  numpy,
  fmt_9,
  spdlog,
  tl-optional,
  metis,
}:

# TODO: This is WIP
# TODO: Unvendor dependencies from third_party
let
  fmt = fmt_9;
in
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

  postPatch = ''
    substituteInPlace symforce/opt/CMakeLists.txt \
      --replace-fail 'function(add_metis)' \
      'function(add_metis)
        find_package(METIS REQUIRED)
        target_link_libraries(''${TARGET} PRIVATE METIS::METIS)
      endfunction()
      function(hacky_mchackface)'
  '';

  patches = [
    ./latest-cmake.patch
    ./fix-pythonpath.patch
    ./fmt-9.patch
    ./spdlog-newer.patch
  ];

  preConfigure = ''
    export CMAKE_LIBRARY_PATH="${fmt.dev}/:$CMAKE_LIBRARY_PATH"
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
    ply
    numpy
    fmt
    spdlog
    tl-optional
    metis
  ];

  meta = {
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
