{ lib
, buildPythonPackage
, fetchPypi
, pkg-config
, pytest
, pytest-runner
, cffi
, secp256k1
}:

buildPythonPackage rec {
  pname = "secp256k1";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82c06712d69ef945220c8b53c1a0d424c2ff6a1f64aee609030df79ad8383397";
  };

  nativeBuildInputs = [ pkg-config ];
  checkInputs = [ pytest pytest-runner ];
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
    # don't do hacky tarball download + setuptools check
    sed -i '38,54d' setup.py
    substituteInPlace setup.py --replace ", 'pytest-runner==2.6.2'" ""
  '';

  meta = {
    homepage = "https://github.com/ludbb/secp256k1-py";
    description = "Python FFI bindings for secp256k1";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ];
  };
}
