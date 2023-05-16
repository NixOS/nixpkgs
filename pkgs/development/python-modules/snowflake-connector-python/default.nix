{ lib
, asn1crypto
, buildPythonPackage
<<<<<<< HEAD
, pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, certifi
, cffi
, charset-normalizer
, fetchPypi
, filelock
, idna
<<<<<<< HEAD
, keyring
, oscrypto
, packaging
, platformdirs
=======
, oscrypto
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pycryptodomex
, pyjwt
, pyopenssl
, pythonOlder
, pytz
, requests
, setuptools
<<<<<<< HEAD
, sortedcontainers
, tomlkit
, typing-extensions
, wheel
=======
, typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
<<<<<<< HEAD
  version = "3.2.0";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Z2oNyhbefBIJAKoaX85kQIM7CmD3ZoK3zPFmeWcoLKM=";
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

=======
    hash = "sha256-F0EbgRSS/kYKUDPhf6euM0eLqIqVjQsHC6C9ZZSRCIE=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "charset_normalizer>=2,<3" "charset_normalizer" \
      --replace "pyOpenSSL>=16.2.0,<23.0.0" "pyOpenSSL"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    asn1crypto
    certifi
    cffi
    charset-normalizer
    filelock
    idna
    oscrypto
<<<<<<< HEAD
    packaging
    platformdirs
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pycryptodomex
    pyjwt
    pyopenssl
    pytz
    requests
<<<<<<< HEAD
    sortedcontainers
    tomlkit
    typing-extensions
  ];

  passthru.optional-dependencies = {
    secure-local-storage = [ keyring ];
  };

=======
    setuptools
    typing-extensions
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
