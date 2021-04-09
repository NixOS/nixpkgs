{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, requests
, matrix-client
, distro
, cryptography
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zulip";
  version = "0.7.1";

  disabled = !isPy3k;

  # no sdist on PyPI
  src = fetchFromGitHub {
    owner = "zulip";
    repo = "python-zulip-api";
    rev = version;
    sha256 = "0da1ki1v252avy27j6d7snnc0gyq0xa9fypm3qdmxhw2w79d6q36";
  };
  sourceRoot = "source/zulip";

  propagatedBuildInputs = [
    requests
    matrix-client
    distro

    # from requests[security]
    cryptography
    pyopenssl
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export COLUMNS=80
  '';

  pythonImportsCheck = [ "zulip" ];

  meta = with lib; {
    description = "Bindings for the Zulip message API";
    homepage = "https://github.com/zulip/python-zulip-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
