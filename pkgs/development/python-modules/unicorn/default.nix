{ lib
, stdenv
, buildPythonPackage
, setuptools
, unicorn-emu
}:

buildPythonPackage rec {
  pname = "unicorn";
  version = lib.getVersion unicorn-emu;
  format = "setuptools";

  src = unicorn-emu.src;

  sourceRoot = "source/bindings/python";

  prePatch = ''
    ln -s ${unicorn-emu}/lib/libunicorn${stdenv.targetPlatform.extensions.sharedLibrary} prebuilt/
    ln -s ${unicorn-emu}/lib/libunicorn.a prebuilt/
  '';

  propagatedBuildInputs = [
    setuptools
  ];

  # No tests present
  doCheck = false;

  pythonImportsCheck = [
    "unicorn"
  ];

  meta = with lib; {
    description = "Python bindings for Unicorn CPU emulator engine";
    homepage = "https://www.unicorn-engine.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bennofs ris ];
  };
}
