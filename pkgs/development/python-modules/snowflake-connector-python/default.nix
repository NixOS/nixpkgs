{ lib
, asn1crypto
, buildPythonPackage
, pythonRelaxDepsHook
, certifi
, cffi
, charset-normalizer
, fetchPypi
, filelock
, idna
, keyring
, oscrypto
, pycryptodomex
, pyjwt
, pyopenssl
, pythonOlder
, pytz
, requests
, setuptools
, typing-extensions
, wheel
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F0EbgRSS/kYKUDPhf6euM0eLqIqVjQsHC6C9ZZSRCIE=";
  };

  # snowflake-connector-python requires arrow 10.0.1, which we don't have in
  # nixpkgs, so we cannot build the C extensions that use it. thus, patch out
  # cython and pyarrow from the build dependencies
  #
  # keep an eye on following issue for improvements to this situation:
  #
  #   https://github.com/snowflakedb/snowflake-connector-python/issues/1144
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"cython",' "" \
      --replace '"pyarrow>=10.0.1,<10.1.0",' ""
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
    wheel
  ];

  pythonRelaxDeps = [
    "pyOpenSSL"
    "charset-normalizer"
    "cryptography"
  ];

  propagatedBuildInputs = [
    asn1crypto
    certifi
    cffi
    charset-normalizer
    filelock
    idna
    oscrypto
    pycryptodomex
    pyjwt
    pyopenssl
    pytz
    requests
    setuptools
    typing-extensions
  ];

  passthru.optional-dependencies = {
    secure-local-storage = [ keyring ];
  };

  # Tests require encrypted secrets, see
  # https://github.com/snowflakedb/snowflake-connector-python/tree/master/.github/workflows/parameters
  doCheck = false;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.connector"
  ];

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-connector-python/blob/v${version}/DESCRIPTION.md";
    description = "Snowflake Connector for Python";
    homepage = "https://github.com/snowflakedb/snowflake-connector-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
