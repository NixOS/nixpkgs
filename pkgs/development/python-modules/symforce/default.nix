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
  symengine,
  symforce-sym,
  jinja2,
  graphviz,
  ruff,
  scipy,
  sympy,
  sortedcontainers,
  llvmPackages,
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

    # third_party/symengine[py] gets vendor-built from scratch via
    # ExternalProject_Add (network-dependent, and symenginepy's own vendored
    # cmake/FindPython.cmake uses distutils.sysconfig, removed in Python
    # 3.12+) even though nothing in the C++/pybind build actually links
    # against it - it's purely there to also install a Python symengine
    # package for symforce's own Python code to import. Use the real
    # nixpkgs python3Packages.symengine instead.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'option(SYMFORCE_BUILD_SYMENGINE "Build symengine[py]" ON)' \
        'option(SYMFORCE_BUILD_SYMENGINE "Build symengine[py]" OFF)'

    # symforce/pybind (cc_sym) is a separate, optional C++ Python-extension
    # acceleration layer gated behind its own option - not needed for
    # symforce's core (pure-Python) symbolic/codegen functionality that
    # px4-uorb-headers actually uses, and it has its own, separate set of
    # fmt-9/pybind11-version compile issues (see setup-py-deps.patch below
    # for the matching setup.py side of this).
    substituteInPlace CMakeLists.txt \
      --replace-fail 'option(SYMFORCE_BUILD_CC_SYM "Build cc_sym and related targets for python wrapping" ON)' \
        'option(SYMFORCE_BUILD_CC_SYM "Build cc_sym and related targets for python wrapping" OFF)'

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
    # setup.py unconditionally declares a "cc_sym" extension module and a
    # custom install step that copies the vendored symenginepy's compiled
    # symengine_wrapper.so and runs a second `cmake --install` for cc_sym's
    # extra libraries - none of which get built now that
    # SYMFORCE_BUILD_SYMENGINE/SYMFORCE_BUILD_CC_SYM are off above (real
    # nixpkgs python3Packages.symengine is used instead, and cc_sym - a
    # separate, optional C++ Python-extension acceleration layer with its
    # own set of fmt-9/pybind11-version compile issues - isn't needed for
    # symforce's core Python symbolic/codegen functionality). Also drops
    # the "clang-format<21.1.3" upper bound from install_requires: no
    # python3Packages.clang-format wrapper exists, and format_util.py's
    # own clang_format import already falls back to a bare "clang-format"
    # PATH lookup when that module isn't installed (see
    # llvmPackages.clang-tools in propagatedBuildInputs below), so pinning
    # a python-level version for it isn't meaningful here anyway.
    ./setup-py-deps.patch
    # symforce/internal/symbolic.py's `from symengine import Mod` was never
    # a real symengine API: it's purely a long-standing symforce-internal
    # patch to their own now-unused vendored symenginepy snapshot (see
    # symforce-org/symforce@cd05477, "TODO(hayk): Actually put into C++"),
    # reapplied across vendored-copy version bumps rather than ever having
    # existed upstream. Define it locally with the identical formula
    # instead, now that the real nixpkgs symengine is used.
    ./symengine-mod-shim.patch
    # Same situation as symengine-mod-shim.patch above, for SignNoZero/
    # CopysignNoZero (symforce-org/symforce@d0203757, "Custom functions for
    # (copy)sign_no_zero") - not real symengine APIs either. Defined here
    # using the exact algebraic identities the sympy-backend classes
    # already use for their own numeric fallback.
    ./symengine-signnozero-shim.patch
    # Same situation as symengine-mod-shim.patch above, for DataBuffer
    # (symforce-org/symforce's own DataBuffer/DataBufferElement additions
    # to their now-unused vendored symenginepy snapshot) - not a real
    # symengine API.
    ./symengine-databuffer-shim.patch
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
    metis
    symengine
    symforce-sym
    jinja2
    graphviz
    ruff
    scipy
    sympy
    sortedcontainers
  ];

  # format_util.py's format_cpp() shells out to a bare "clang-format" on
  # PATH when the (unpackaged) clang_format PyPI module isn't importable -
  # see setup-py-deps.patch.
  propagatedBuildInputs = [ llvmPackages.clang-tools ];

  meta = {
    description = "Fast symbolic computation, code generation, and nonlinear optimization for robotics";
    homepage = "https://github.com/symforce-org/symforce";
    changelog = "https://github.com/symforce-org/symforce/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
