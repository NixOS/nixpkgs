{ lib
, buildPythonPackage
, fetchPypi
, pkgconfig
, pytest
, pytestrunner
, cffi
, secp256k1
}:

buildPythonPackage rec {
  pname = "secp256k1";
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3b43e02d321c09eafa769a6fc2c156f555cab3a7db62175ef2fd21e16cdf20c";
  };

  nativeBuildInputs = [ pkgconfig ];
  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ cffi secp256k1 ];

  # Tests are not included in archive
  doCheck = false;

  preConfigure = ''
    cp -r ${secp256k1.src} libsecp256k1
    touch libsecp256k1/autogen.sh
    export INCLUDE_DIR=${secp256k1}/include
    export LIB_DIR=${secp256k1}/lib
  '';

  checkPhase = ''
    py.test tests
  '';

  postPatch = ''
    sed -i '38,45d' setup.py
    substituteInPlace setup.py --replace ", 'pytest-runner==2.6.2'" ""
  '';

  meta = {
    homepage = "https://github.com/ludbb/secp256k1-py";
    description = "Python FFI bindings for secp256k1";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ chris-martin ];
  };
}
