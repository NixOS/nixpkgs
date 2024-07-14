{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  pytestCheckHook,
  cffi,
  secp256k1,
}:

buildPythonPackage rec {
  pname = "secp256k1";
  version = "0.14.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gsBnEtae+UUiDItTwaDUJML/ah9kruYJAw33mtg4M5c=";
  };

  postPatch = ''
    # don't do hacky tarball download + setuptools check
    sed -i '38,54d' setup.py
    substituteInPlace setup.py --replace ", 'pytest-runner==2.6.2'" ""
  '';

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    cffi
    secp256k1
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests are not included in archive
  doCheck = false;

  preConfigure = ''
    cp -r ${secp256k1.src} libsecp256k1
    export INCLUDE_DIR=${secp256k1}/include
    export LIB_DIR=${secp256k1}/lib
  '';

  meta = {
    homepage = "https://github.com/ludbb/secp256k1-py";
    description = "Python FFI bindings for secp256k1";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ];
  };
}
