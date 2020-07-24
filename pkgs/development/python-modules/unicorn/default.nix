{ stdenv, buildPythonPackage, setuptools, unicorn-emu }:

buildPythonPackage rec {
  pname = "unicorn";
  version = stdenv.lib.getVersion unicorn-emu;

  src = unicorn-emu.src;
  sourceRoot = "unicorn-${version}/bindings/python";

  prePatch = ''
    ln -s ${unicorn-emu}/lib/libunicorn${stdenv.targetPlatform.extensions.sharedLibrary} prebuilt/
    ln -s ${unicorn-emu}/lib/libunicorn.a prebuilt/
  '';

  propagatedBuildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Python bindings for Unicorn CPU emulator engine";
    homepage = "http://www.unicorn-engine.org/";
    license = [ licenses.gpl2 ];
    maintainers = with maintainers; [ bennofs ris ];
  };
}
