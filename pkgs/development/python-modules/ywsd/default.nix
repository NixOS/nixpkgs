{ lib
, aiopg
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, python-yate
, pyyaml
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "ywsd";
  version = "0.13.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eventphone";
    repo = "ywsd";
    rev = "refs/tags/v${version}";
    hash = "sha256-eNDRhnXQYnlxRJ5xfJ6nlYALoJd2ecdLmRTwBS2/H6A=";
  };

  propagatedBuildInputs = [
    aiopg
    aiohttp
    python-yate
    pyyaml
    # ywsd requires sqlalchemy 1.4.x
    (sqlalchemy.overridePythonAttrs (oldAttrs: rec {
      version = "1.4.49";
      src = fetchFromGitHub {
        owner = "sqlalchemy";
        repo = "sqlalchemy";
        rev = "refs/tags/rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
        hash = "sha256-v7xHfN8we7BZ1eQwrQ/jMnlWgxsmrdYPsHpAFeS9Fhg=";
      };
      doCheck = false;
    }))
  ];

  # tests are officially not supported by upstream and require docker
  doCheck = false;

  pythonImportsCheck = [
    "ywsd"
  ];

  meta = with lib; {
    description = "Yate routing engine for event telephone networks";
    homepage = "https://github.com/eventphone/ywsd";
    license = with licenses; [ agpl3 ];
    maintainers = with maintainers; [ clerie ];
  };
}
