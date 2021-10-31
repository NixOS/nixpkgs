{ lib
, buildPythonPackage
, fetchFromGitHub
, pyperclip
, urwid
}:

buildPythonPackage rec {
  version = "0.2.1";
  pname = "upass";

  src = fetchFromGitHub {
    owner = "Kwpolska";
    repo = "upass";
    rev = "v${version}";
    sha256 = "0bgplq07dmlld3lp6jag1w055glqislfgwwq2k7cb2bzjgvysdnj";
  };

  propagatedBuildInputs = [ pyperclip urwid ];

  doCheck = false;

  meta = with lib; {
    description = "Console UI for pass";
    homepage = "https://github.com/Kwpolska/upass";
    license = licenses.bsd3;
  };

}
