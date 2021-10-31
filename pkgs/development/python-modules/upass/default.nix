{ lib
, buildPythonPackage
, fetchFromGitHub
, pyperclip
, urwid
}:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "upass";

  src = fetchFromGitHub {
    owner = "Kwpolska";
    repo = "upass";
    rev = "v${version}";
    sha256 = "sha256-1y/OE8Gbc8bShEiLWg8w4J6icAcoldYQLI10WSQuO1Y=";
  };

  propagatedBuildInputs = [ pyperclip urwid ];

  doCheck = false;

  meta = with lib; {
    description = "Console UI for pass";
    homepage = "https://github.com/Kwpolska/upass";
    license = licenses.bsd3;
  };

}
