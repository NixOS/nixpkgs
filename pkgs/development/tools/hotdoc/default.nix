{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
  replaceVars,
  pkg-config,
  cmake,
  flex,
  glib,
  json-glib,
  libxml2,
  llvmPackages,
  gst_all_1,
}:

python3Packages.buildPythonApplication rec {
  pname = "hotdoc";
  version = "0.17.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xNXf9kfwOqh6HS0GA10oGe3QmbkWNeOy7jkIKTV66fw=";
  };

  patches = [
    (replaceVars ./clang.patch {
      clang = lib.getExe llvmPackages.clang;
      libclang_lib_dir = "${lib.getLib llvmPackages.libclang}/lib";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    flex
  ];

  buildInputs = [
    glib
    json-glib
    libxml2
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
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

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  # CMake is used to build CMARK, but the build system is still python
  dontUseCmakeConfigure = true;

  # Ensure C+GI+GST extensions are built and can be imported
  pythonImportsCheck = [
    "hotdoc.extensions.c.c_extension"
    "hotdoc.extensions.gi.gi_extension"
    "hotdoc.extensions.gst.gst_extension"
  ];

  # Only the installed hotdoc pacakge contains the CMARK ext module
  # so we get rid of the hotdoc package in our cwd
  preCheck = ''
    rm -r hotdoc
  '';

  pytestFlags = [
    # Run the tests in the installed hotdoc package
    "--pyargs"
    "hotdoc"
  ];

  disabledTests = [
    # Test does not correctly handle path normalization for test comparison
    "test_cli_overrides"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Test does not correctly handle absolute /home paths on Darwin (even fake ones)
    "test_index"
  ];

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
