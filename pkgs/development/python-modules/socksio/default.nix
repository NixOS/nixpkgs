{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "socksio";
  version = "1.0.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "socksio";
    rev = version;
    sha256 = "sha256-Q5EFEyRXbhMzJbKGwkZxW7Trs43BpumgOhx5360TKJ8=";
  };

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [
    # clear coverage options from default options
    "--override-ini addopts="
  ];

  meta = with lib; {
    description = "Sans-I/O implementation of SOCKS4, SOCKS4A, and SOCKS5";
    homepage = "https://github.com/sethmlarson/socksio";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
