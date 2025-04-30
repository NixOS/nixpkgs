{
  lib,
  stdenv,
  fetchPypi,
  pkg-config,
  cmake,
  flex,
  glib,
  json-glib,
  libxml2,
  llvmPackages,
  gst_all_1,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "hotdoc";
  version = "0.17.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xNXf9kfwOqh6HS0GA10oGe3QmbkWNeOy7jkIKTV66fw=";
  };

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    pkg-config
    cmake
    flex
    llvmPackages.libclang
  ];

  # CMake is used to build CMARK, but the build system is still python
  dontUseCmakeConfigure = true;

  buildInputs = [
    glib
    json-glib
    libxml2.dev
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ stdenv.cc.libc.dev ];

  dependencies = with python3Packages; [
    appdirs
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
    backports-entry-points-selectable
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  # Ensure C+GI+GST extensions are built and can be imported
  pythonImportsCheck = [
    "hotdoc.extensions.c.c_extension"
    "hotdoc.extensions.gi.gi_extension"
    "hotdoc.extensions.gst.gst_extension"
  ];

  # Run the tests by package instead of current dir
  pytestFlagsArray = [
    "--pyargs"
    "hotdoc"
  ];

  disabledTests =
    [
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
      --replace-fail "shutil.which('llvm-config')" "True" \
      --replace-fail "['clang'," "['${llvmPackages.libclang}/bin/clang'," \
      --replace-fail "version = subprocess.check_output(" 'version = "${lib.versions.major llvmPackages.libclang.version}"' \
      --replace-fail "[LLVM_CONFIG, '--version']).strip().decode()" "" \
      --replace-fail "prefix = subprocess.check_output(" 'prefix = "${lib.getLib llvmPackages.libclang}"' \
      --replace-fail "[LLVM_CONFIG, '--prefix']).strip().decode()" "" \
      --replace-fail "subprocess.check_output([LLVM_CONFIG, '--libdir']).strip().decode()" '"${lib.getLib llvmPackages.libclang}/lib"'
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

  meta = {
    description = "Tastiest API documentation system";
    homepage = "https://hotdoc.github.io";
    license = [ lib.licenses.lgpl21Plus ];
    maintainers = [ ];
  };
}
