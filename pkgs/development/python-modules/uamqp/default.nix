{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cython_0,
  certifi,
  CFNetwork,
  cmake,
  CoreFoundation,
  openssl,
  Security,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "uamqp";
  version = "1.6.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-uamqp-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-L4E7nnsVZ/VrOM0t4KtztU9ALmtGfi1vDzUi0ogtZOc=";
  };

  patches =
    lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
      ./darwin-azure-c-shared-utility-corefoundation.patch
    ]
    ++ [
      (fetchpatch {
        name = "CVE-2024-25110.patch";
        url = "https://github.com/Azure/azure-uamqp-c/commit/30865c9ccedaa32ddb036e87a8ebb52c3f18f695.patch";
        stripLen = 1;
        extraPrefix = "src/vendor/azure-uamqp-c/";
        hash = "sha256-igzZqTLUUyuNcpCUbYHI4RXmWxg+7EC/yyD4DBurR2M=";
      })
      (fetchpatch {
        name = "CVE-2024-27099.patch";
        url = "https://github.com/Azure/azure-uamqp-c/commit/2ca42b6e4e098af2d17e487814a91d05f6ae4987.patch";
        stripLen = 1;
        extraPrefix = "src/vendor/azure-uamqp-c/";
        # other files are just tests which aren't run from the python
        # builder anyway
        includes = [ "src/vendor/azure-uamqp-c/src/link.c" ];
        hash = "sha256-EqDfG1xAz5CG8MssSSrz8Yrje5qwF8ri1Kdw+UUu5ms=";
      })
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
    cython_0
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      CoreFoundation
      CFNetwork
      Security
    ];

  propagatedBuildInputs = [ certifi ];

  dontUseCmakeConfigure = true;

  preCheck = ''
    # remove src module, so tests use the installed module instead
    rm -r uamqp
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "uamqp" ];

  meta = with lib; {
    description = "AMQP 1.0 client library for Python";
    homepage = "https://github.com/Azure/azure-uamqp-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
