{
  lib,
  stdenv,
  buildPythonApplication,
  fetchPypi,
  replaceVars,
  clang,
  libclang,
  pytestCheckHook,
  pkg-config,
  cmake,
  flex,
  glib,
  json-glib,
  libxml2,
  appdirs,
  backports-entry-points-selectable,
  dbus-deviation,
  faust-cchardet,
  feedgen,
  lxml,
  networkx,
  pkgconfig,
  pyyaml,
  schema,
  setuptools,
  toposort,
  wheezy-template,
  llvmPackages,
  gst_all_1,
}:

buildPythonApplication rec {
  pname = "hotdoc";
  version = "0.17.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xNXf9kfwOqh6HS0GA10oGe3QmbkWNeOy7jkIKTV66fw=";
  };

  patches = [
    (replaceVars ./clang.patch {
      clang = lib.getExe clang;
      libclang = "${lib.getLib libclang}/lib/libclang${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [
    pkg-config
    cmake
    flex
  ];

  buildInputs = [
    glib
    json-glib
    libxml2.dev
  ];

  dependencies = [
    appdirs
    backports-entry-points-selectable
    dbus-deviation
    faust-cchardet
    feedgen
    lxml
    networkx
    pkgconfig
    pyyaml
    schema
    setuptools # for pkg_resources
    toposort
    wheezy-template
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # CMake is used to build CMARK, but the build system is still python
  dontUseCmakeConfigure = true;

  # Ensure C+GI+GST extensions are built and can be imported
  pythonImportsCheck = [
    "hotdoc.extensions.c.c_extension"
    "hotdoc.extensions.gi.gi_extension"
    "hotdoc.extensions.gst.gst_extension"
  ];

  pytestFlags = [
    # Run the tests by package instead of current dir
    "--pyargs"
    "hotdoc"
  ];

  disabledTestPaths = [
    # Executing hotdoc exits with code 1
    "tests/test_hotdoc.py::TestHotdoc::test_basic"
    "tests/test_hotdoc.py::TestHotdoc::test_explicit_conf_file"
    "tests/test_hotdoc.py::TestHotdoc::test_implicit_conf_file"
    "tests/test_hotdoc.py::TestHotdoc::test_private_folder"
  ];

  disabledTests = [
    # Test does not correctly handle path normalization for test comparison
    "test_cli_overrides"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Test does not correctly handle absolute /home paths on Darwin (even fake ones)
    "test_index"
  ];

  # Hardcode libclang paths
  postPatch = ''
    substituteInPlace hotdoc/extensions/c/c_extension.py \
      --replace "shutil.which('llvm-config')" 'True' \
      --replace "subprocess.check_output(['llvm-config', '--version']).strip().decode()" '"${lib.versions.major llvmPackages.libclang.version}"' \
      --replace "subprocess.check_output(['llvm-config', '--prefix']).strip().decode()" '"${lib.getLib llvmPackages.libclang}"' \
      --replace "subprocess.check_output(['llvm-config', '--libdir']).strip().decode()" '"${lib.getLib llvmPackages.libclang}/lib"'
  '';

  # Make pytest run from a temp dir to have it pick up installed package for cmark
  preCheck = ''
    pushd $TMPDIR
  '';
  postCheck = ''
    popd
  '';

  passthru.tests = {
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  meta = with lib; {
    description = "Tastiest API documentation system";
    homepage = "https://hotdoc.github.io/";
    license = [ licenses.lgpl21Plus ];
    maintainers = [ ];
  };
}
