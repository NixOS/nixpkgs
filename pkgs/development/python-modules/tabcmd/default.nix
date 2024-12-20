{
  lib,
  appdirs,
  argparse,
  buildPythonPackage,
  doit,
  fetchPypi,
  ftfy,
  mock,
  pyinstaller-versionfile,
  pytest-order,
  pytestCheckHook,
  python,
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
  tableauserverclient,
  types-appdirs,
  types-mock,
  types-requests,
  types-setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "tabcmd";
  version = "2.0.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wyfKy0g2btdNMNviCd7brB+lwZvPcZ3/DnymdVjCGFg=";
  };

  prePatch = ''
    # Remove an unneeded dependency that can't be resolved
    # https://github.com/tableau/tabcmd/pull/282
    sed -i "/'argparse',/d" pyproject.toml
  '';

  pythonRelaxDeps = [
    "tableauserverclient"
    "urllib3"
  ];

  build-system = [ setuptools ];

  dependencies = [
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
    pytest-order
    pytestCheckHook
  ];

  # Create a "tabcmd" executable
  postInstall = ''
    # Create a directory for our wrapped binary.
    mkdir -p $out/bin

    cp -r build/lib/tabcmd/__main__.py $out/bin/

    # Create a 'tabcmd' script with python3 shebang
    echo "#!${python.interpreter}" > $out/bin/tabcmd

    # Append __main__.py contents
    cat $out/bin/__main__.py >> $out/bin/tabcmd

    # Make it executable.
    chmod +x $out/bin/tabcmd
  '';

  pythonImportsCheck = [ "tabcmd" ];

  meta = with lib; {
    broken = true;
    description = "Command line client for working with Tableau Server";
    homepage = "https://github.com/tableau/tabcmd";
    changelog = "https://github.com/tableau/tabcmd/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "tabcmd";
  };
}
