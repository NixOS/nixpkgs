{
  lib,
  attrs,
  buildPythonPackage,
  docopt,
  fetchPypi,
  libX11,
  libXext,
  libXres,
  meson-python,
  meson,
  pillow,
  pkg-config,
  psutil,
  xlib,
}:

buildPythonPackage rec {
  pname = "ueberzug";
  version = "18.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1Lk4E5YwEq2mUnYbIWDhzz9/CCwfXMJ11/TtJ44ugOk=";
  };

  build-system = [
    meson
    meson-python
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libX11
    libXres
    libXext
  ];

  dependencies = [
    attrs
    docopt
    pillow
    psutil
    xlib
  ];

  doCheck = false;

  pythonImportsCheck = [ "ueberzug" ];

  meta = {
    description = "Alternative for w3mimgdisplay";
    homepage = "https://github.com/ueber-devel/ueberzug";
    changelog = "https://github.com/ueber-devel/ueberzug/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "ueberzug";
    platforms = lib.platforms.linux;
  };
}
