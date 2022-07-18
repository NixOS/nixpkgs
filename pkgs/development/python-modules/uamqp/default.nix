{ lib
, stdenv
, buildPythonPackage
, certifi
, CFNetwork
, cmake
, CoreFoundation
, enum34
, fetchpatch
, fetchPypi
, isPy3k
, openssl
, Security
, six
}:

buildPythonPackage rec {
  pname = "uamqp";
  version = "1.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-guhfOMvddC4E+oOmvpeG8GsXEfqLcSHVdtj3w8fF2Vs=";
  };

  patches = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    ./darwin-azure-c-shared-utility-corefoundation.patch
  ];

  postPatch = lib.optionalString (stdenv.isDarwin && !stdenv.isx86_64) ''
    # force darwin aarch64 to use openssl instead of applessl, removing
    # some quirks upstream thinks they need to use openssl on macos
    sed -i \
      -e '/^use_openssl =/cuse_openssl = True' \
      -e 's/\bazssl\b/ssl/' \
      -e 's/\bazcrypto\b/crypto/' \
      setup.py
    sed -i \
      -e '/#define EVP_PKEY_id/d' \
      src/vendor/azure-uamqp-c/deps/azure-c-shared-utility/adapters/x509_openssl.c
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    CFNetwork
    Security
  ];

  propagatedBuildInputs = [
    certifi
    openssl
    six
  ] ++ lib.optionals (!isPy3k) [
    enum34
  ];

  dontUseCmakeConfigure = true;

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "uamqp"
  ];

  meta = with lib; {
    description = "An AMQP 1.0 client library for Python";
    homepage = "https://github.com/Azure/azure-uamqp-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
