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
, packaging
, platformdirs
, pycryptodomex
, pyjwt
, pyopenssl
, pythonOlder
, pytz
, requests
, setuptools
, sortedcontainers
, tomlkit
, typing-extensions
, wheel
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "3.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZU5KH2ikkVRL2PfFqwLrhTHfZ8X0MJ1SU70gQET4obM=";
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
    "platformdirs"
  ];

  propagatedBuildInputs = [
    asn1crypto
    certifi
    cffi
    charset-normalizer
    filelock
    idna
    oscrypto
    packaging
    platformdirs
    pycryptodomex
    pyjwt
    pyopenssl
    pytz
    requests
    sortedcontainers
    tomlkit
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
