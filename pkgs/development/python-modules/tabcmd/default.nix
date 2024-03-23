{ lib
, appdirs
, argparse
, buildPythonPackage
, doit
, fetchPypi
, ftfy
, mock
, pyinstaller-versionfile
, pytestCheckHook
, python3
, pythonOlder
, requests
, pythonRelaxDepsHook
, setuptools
, setuptools-scm
, tableauserverclient
, types-appdirs
, types-mock
, types-requests
, types-setuptools
, urllib3
}:

buildPythonPackage rec {
  pname = "tabcmd";
  version = "2.0.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f9zoYeb4RzcCtgcCYYvvuCuFrjqpP3Fhv38bUWH24+g=";
  };

  pythonRelaxDeps = [
    "tableauserverclient"
    "urllib3"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    appdirs
    argparse
    doit
    ftfy
    pyinstaller-versionfile
    requests
    setuptools-scm
    tableauserverclient
    types-appdirs
    types-mock
    types-requests
    types-setuptools
    urllib3
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  # Remove an unneeded dependency that can't be resolved
  prePatch = ''
    sed -i "/'argparse',/d" pyproject.toml
  '';

  # Create a "tabcmd" executable
  postInstall = ''
    # Create a directory for our wrapped binary.
    mkdir -p $out/bin

    cp -r build/lib/tabcmd/__main__.py $out/bin/

    # Create a 'tabcmd' script with python3 shebang
    echo "#!${python3}/bin/python3" > $out/bin/tabcmd

    # Append __main__.py contents
    cat $out/bin/__main__.py >> $out/bin/tabcmd

    # Make it executable.
    chmod +x $out/bin/tabcmd
  '';


  meta = with lib; {
    description = "A command line client for working with Tableau Server.";
    mainProgram = "tabcmd";
    homepage = "https://github.com/tableau/tabcmd";
    changelog = "https://github.com/tableau/tabcmd/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
