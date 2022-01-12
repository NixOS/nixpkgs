{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, requests
, matrix-client
, distro
, click
, cryptography
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zulip";
  version = "0.8.1";

  disabled = !isPy3k;

  # no sdist on PyPI
  src = fetchFromGitHub {
    owner = "zulip";
    repo = "python-zulip-api";
    rev = version;
    sha256 = "sha256-vYeZEz8nuZYL1stHLa595IbhyNbqqxH4mx7ISbqRAlA=";
  };
  sourceRoot = "${src.name}/zulip";

  propagatedBuildInputs = [
    requests
    matrix-client
    distro
    click

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
