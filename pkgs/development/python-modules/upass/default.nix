{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyperclip,
  urwid,
}:

buildPythonPackage rec {
  pname = "upass";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Kwpolska";
    repo = "upass";
    rev = "v${version}";
    sha256 = "0bgplq07dmlld3lp6jag1w055glqislfgwwq2k7cb2bzjgvysdnj";
  };

  propagatedBuildInputs = [
    pyperclip
    urwid
  ];

  # Projec thas no tests
  doCheck = false;

  postInstall = ''
    export HOME=$(mktemp -d);
    mkdir $HOME/.config
  '';

  pythonImportsCheck = [ "upass" ];

  meta = with lib; {
    description = "Console UI for pass";
    mainProgram = "upass";
    homepage = "https://github.com/Kwpolska/upass";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
