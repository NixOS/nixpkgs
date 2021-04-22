{ lib
, buildPythonPackage
, fetchPypi
, cffi
, pytestCheckHook
, pyserial
}:

buildPythonPackage rec {
  pname = "smbus2";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16yaawaz5r08cscvq5nsy2c46fzhh8i2sn7jf91ygi3nkdcynxk2";
  };

  propagatedBuildInputs = [ cffi ];

  installCheckPhase = ''
    # we want to import the installed module that also contains the compiled library
    rm -rf smbus
  '';

  meta = with lib; {
    description = "A drop-in replacement for smbus-cffi/smbus-python in pure Python";
    homepage = "https://github.com/kplindegaard/smbus2";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
