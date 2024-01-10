{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, certifi
, CFNetwork
, cmake
, CoreFoundation
, libcxxabi
, openssl
, Security
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "uamqp";
  version = "1.6.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-uamqp-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-q8FxM4PBXLD5q68nrUJ+TGkui1yQJ3HHNF7jn+e+HkA=";
  };

  patches = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    ./darwin-azure-c-shared-utility-corefoundation.patch
  ] ++ [
    # Fix incompatible function pointer conversion error with clang 16.
    ./clang-fix-incompatible-function-pointer-conversion.patch
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
    sed -z -i \
      -e 's/OpenSSL 3\nif(LINUX)/OpenSSL 3\nif(1)/' \
      src/vendor/azure-uamqp-c/deps/azure-c-shared-utility/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    cython
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    CFNetwork
    Security
  ];

  propagatedBuildInputs = [
    certifi
  ];

  LDFLAGS = lib.optionals stdenv.isDarwin [
    "-L${lib.getLib libcxxabi}/lib"
  ];

  dontUseCmakeConfigure = true;

  preCheck = ''
    # remove src module, so tests use the installed module instead
    rm -r uamqp
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

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
