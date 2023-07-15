{ lib
, buildPythonPackage
, fetchPypi
, cffi
, py
, pytestCheckHook
, pyserial
, fetchpatch
}:

buildPythonPackage rec {
  pname = "smbus-cffi";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb4195aaabfc01586863f60d3190b5cb1bf8f12622fd597e23e48768dad6bde8";
  };

  patches = [
    # https://github.com/bivab/smbus-cffi/pull/24
    (fetchpatch {
      url = "https://github.com/bivab/smbus-cffi/commit/ba79ae174a9d84e767d95f165c43ee212b1bbb92.patch";
      hash = "sha256-WtRuK5y6fWDEhm0Xy5XqS5yCkn7vXXYtjlOjS90gla4=";
    })
  ];

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  installCheckPhase = ''
    # we want to import the installed module that also contains the compiled library
    rm -rf smbus
    runHook pytestCheckPhase
  '';

  # requires hardware access
  pytestFlagsArray = [ "--ignore=test/test_smbus_integration.py" ];

  nativeCheckInputs = [ py pytestCheckHook pyserial ];

  meta = with lib; {
    description = "Python module for SMBus access through Linux I2C /dev interface";
    homepage = "https://github.com/bivab/smbus-cffi";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
