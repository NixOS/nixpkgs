{ lib
, stdenv
, buildPythonApplication
, fetchPypi
, pytestCheckHook
, python
, pkg-config
, cmake
, flex
, glib
, json-glib
, libxml2
, appdirs
, dbus-deviation
, faust-cchardet
, feedgen
, lxml
, networkx
, pkgconfig
, pyyaml
, schema
, setuptools
, toposort
, wheezy-template
, llvmPackages
, gst_all_1
}:

buildPythonApplication rec {
  pname = "hotdoc";
  version = "0.16";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rxhW1U+d0j4FOKfcRCO2nSndf1Sk/m40hEYGq1Gj6rM=";
  };

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

  propagatedBuildInputs = [
    appdirs
    dbus-deviation
    faust-cchardet
    feedgen
    lxml
    networkx
    pkgconfig
    pyyaml
    schema
    setuptools  # for pkg_resources
    toposort
    wheezy-template
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # CMake is used to build CMARK, but the build system is still python
  dontUseCmakeConfigure = true;

  # Ensure C+GI+GST extensions are built and can be imported
  pythonImportsCheck = [
    "hotdoc.extensions.c.c_extension"
    "hotdoc.extensions.gi.gi_extension"
    "hotdoc.extensions.gst.gst_extension"
  ];

  # Run the tests by package instead of current dir
  pytestFlagsArray = [ "${builtins.placeholder "out"}/${python.sitePackages}" "--pyargs" "hotdoc" ];

  disabledTests = [
    # Test does not correctly handle path normalization for test comparison
    "test_cli_overrides"
  ] ++ lib.optionals stdenv.isDarwin [
    # Test does not correctly handle absolute /home paths on Darwin (even fake ones)
    "test_index"
  ];

  # Hardcode libclang paths
  postPatch = ''
    substituteInPlace hotdoc/extensions/c/c_extension.py \
      --replace-fail "shutil.which('llvm-config')" 'True' \
      --replace-fail "$(echo -e "subprocess.check_output(\n            ['clang', '--print-resource-dir']).strip().decode()")" '""' \
      --replace-fail "$(echo -e "subprocess.check_output(\n        ['llvm-config', '--version']).strip().decode()")" '"${lib.versions.major llvmPackages.libclang.version}"' \
      --replace-fail "$(echo -e "subprocess.check_output(\n        ['llvm-config', '--prefix']).strip().decode()")" '"${llvmPackages.libclang.lib}"' \
      --replace-fail "subprocess.check_output(['llvm-config', '--libdir']).strip().decode()" '"${llvmPackages.libclang.lib}/lib"'
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
    description = "The tastiest API documentation system";
    homepage = "https://hotdoc.github.io/";
    license = [ licenses.lgpl21Plus ];
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
