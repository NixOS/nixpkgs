{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  cython,
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
  version = "1.6.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-uamqp-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-HTIOHheCrvyI7DwA/UcUXk/fbesd29lvUvJ9TAeG3CE=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-clang16-compatibility.patch";
      url = "https://github.com/Azure/azure-uamqp-python/commit/bd6d9ef5a8bca3873e1e66218fd09ca787b8064e.patch";
      hash = "sha256-xtnIVjB71EPJp/QjLQWctcSDds5s6n4ut+gnvp3VMlM=";
    })
  ];

  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isx86_64) ''
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

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreFoundation
      CFNetwork
      Security
    ];

  dependencies = [ certifi ];

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
