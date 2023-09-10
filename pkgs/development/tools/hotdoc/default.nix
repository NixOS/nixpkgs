{ lib
, stdenv
, buildPythonApplication
, fetchPypi
, pytestCheckHook
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
, libclang
, gst_all_1
}:

buildPythonApplication rec {
  pname = "hotdoc";
  version = "0.13.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ESOmWeLJSXLDKBPsMBGR0zPbJHEqg/fj0G3VjUfPAJg=";
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
  pytestFlagsArray = [ "--pyargs" "hotdoc" ];

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
      --replace "shutil.which('llvm-config')" 'True' \
      --replace "subprocess.check_output(['llvm-config', '--version']).strip().decode()" '"${libclang.version}"' \
      --replace "subprocess.check_output(['llvm-config', '--prefix']).strip().decode()" '"${libclang.lib}"' \
      --replace "subprocess.check_output(['llvm-config', '--libdir']).strip().decode()" '"${libclang.lib}/lib"'
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
