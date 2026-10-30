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
  pybind11,
  cython,
  skymarshal,
  gmp,
}:

# TODO: This is WIP
# TODO: Unvendor dependencies from third_party
let
  fmt = fmt_9;
in
buildPythonPackage rec {
  pname = "symforce";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symforce-org";
    repo = "symforce";
    tag = "v${version}";
    hash = "sha256-mEIszv14bHY/kCafIcXmG1h4sXQXTwVf5HhObDtm/SI=";
  };

  postPatch = ''
    # setup.py's own declared build-dependency bound ("cython>=3,<3.1.0")
    # predates this nixpkgs' cython; use whatever's actually packaged instead
    # of pinning backward to satisfy a stale upper bound.
    substituteInPlace setup.py \
      --replace-fail '"cython>=3,<3.1.0"' '"cython>=3"'

    substituteInPlace symforce/opt/CMakeLists.txt \
      --replace-fail 'function(add_metis)' \
      'function(add_metis)
        find_package(METIS REQUIRED)
        # Downstream (e.g. symforce_cholesky below) links against a plain
        # "metis" target, matching the name METIS'"'"'s own CMakeLists.txt
        # gives it when built via the FetchContent path this replaces; alias
        # that name to the METIS::metis imported target find_package() gives
        # us so the rest of this file does not need to change.
        add_library(metis ALIAS METIS::metis)
      endfunction()
      function(hacky_mchackface)'
  '';

  patches = [
    ./latest-cmake.patch
    ./fmt-9.patch
    ./spdlog-newer.patch
  ];

  # setup.py drives its own cmake invocation internally (there's no
  # pyproject.toml [build-system], so this is a plain legacy setup.py build);
  # letting cmake's setup hook take over configurePhase instead just leaves
  # the build stuck inside the throwaway build/ dir it cd's into, breaking
  # the subsequent pypa build step.
  dontUseCmakeConfigure = true;

  preConfigure = ''
    export CMAKE_LIBRARY_PATH="${fmt.dev}/:$CMAKE_LIBRARY_PATH"
    # symforce/pybind/CMakeLists.txt does a bare find_package(pybind11 ...),
    # falling back to FetchContent (blocked in the sandbox) if that fails.
    # pybind11's own CMake config isn't under a standard find_package search
    # path (it lives under the Python package's site-packages, not
    # lib/cmake), so point at it directly the same way pybind11's own docs
    # recommend doing via pybind11.get_cmake_dir().
    export pybind11_DIR="${pybind11}/${pybind11.pythonModule.sitePackages}/pybind11/share/cmake/pybind11"
  '';

  build-system = [
    setuptools
    cmake
    pip
    setuptools-scm
    git # TODO: Upstream patch that also catches FileNotFoundError when git not installed
    pybind11
    cython
    skymarshal
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
    gmp # linked by the vendored third_party/symengine subbuild
    metis
  ];

  meta = {
    description = "Fast symbolic computation, code generation, and nonlinear optimization for robotics";
    homepage = "https://github.com/symforce-org/symforce";
    changelog = "https://github.com/symforce-org/symforce/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
