{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "agda-pkg";
  version = "0.1.50";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wpw90kw3danw91m3jzfdn7zmclimmiz74f77mpij9b1w6wvhm11";
  };

  # Checks need internet access, so we just check the program executes
  # At the moment the help page needs to write to $HOME, this can
  # be removed if https://github.com/agda/agda-pkg/issues/40 is fixed
  checkPhase = ''
    HOME=$NIX_BUILD_TOP $out/bin/apkg --help > /dev/null
  '';

  propagatedBuildInputs = [
    click
    GitPython
    pony
    whoosh
    natsort
    click-log
    requests
    humanize
    distlib
    jinja2
    pyyaml
    ponywhoosh
  ];

  meta = with lib; {
    homepage = "https://agda.github.io/agda-pkg/";
    description = "Package manager for Agda";
    license = licenses.mit;
    maintainers = with maintainers; [ alexarice ];
  };
}
