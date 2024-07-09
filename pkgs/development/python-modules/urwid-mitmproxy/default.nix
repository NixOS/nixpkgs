{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "urwid-mitmproxy";
  version = "2.1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "urwid-mitmproxy";
    rev = "refs/tags/${version}";
    hash = "sha256-93AauYWbrG/2smAhbNKGE0twGJZ2u9gBetlXGCpciH8=";
  };

  pythonImportsCheck = [ "urwid" ];

  # Tests which assert on strings don't decode results correctly, see urwid
  doCheck = false;

  meta = with lib; {
    description = "Urwid fork used by mitmproxy";
    homepage = "https://github.com/mitmproxy/urwid-mitmproxy";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
  };
}
