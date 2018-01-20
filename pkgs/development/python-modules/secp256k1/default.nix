{ lib
, buildPythonPackage
, fetchPypi
, pkgconfig
, pytest_28
, pytestrunner
, cffi
, secp256k1
}:

buildPythonPackage rec {
  pname = "secp256k1";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zrjxvzxqm4bz2jcy8sras8jircgbs6dkrw8j3nc6jhvzlikwwxl";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pytest_28 pytestrunner ];
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

  meta = {
    homepage = https://github.com/ludbb/secp256k1-py;
    description = "Python FFI bindings for secp256k1";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ chris-martin ];
  };
}