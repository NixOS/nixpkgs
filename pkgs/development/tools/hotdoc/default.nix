{ lib
, python3Packages
, pkg-config
, flex
, cmake
, glib
, json-glib
, libxml2
}:

python3Packages.buildPythonApplication rec {
  pname = "hotdoc";
  version = "0.12.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0nypvcqp4b0qfps35f7mz3d90zjh0v5wawpd06ra28q92nxblx17";
  };

  nativeBuildInputs = [
    pkg-config
    flex
    cmake
  ];

  # Cmake is needed to build a c extension CMARK, but the build system is still
  # python
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    lxml
    schema
    appdirs
    wheezy-template
    toposort
    xdg
    dbus-deviation
    setuptools
    pkgconfig
    networkx
    cchardet
  ];

  buildInputs = [
    glib
    json-glib
    libxml2
  ];

  prePatch =
    # https://github.com/hotdoc/hotdoc/issues/210
  ''
    substituteInPlace setup.py \
      --replace wheezy.template==0.1.167 wheezy.template \
      --replace networkx==1.11 networkx \
      --replace pkgconfig==1.1.0 pkgconfig
  '';

  # https://hotdoc.github.io/installing.html#build-options
  HOTDOC_BUILD_C_EXTENSION = "enabled";

  meta = {
    description = "The tastiest API documentation system";
    homepage = "https://hotdoc.github.io/";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}

