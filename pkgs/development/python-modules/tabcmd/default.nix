{ lib
, buildPythonPackage
, python3
, pythonOlder
, fetchPypi
, ftfy
, appdirs
, requests
, setuptools-scm
, types-mock
, types-appdirs
, types-requests
, types-setuptools
, argparse
, doit
, pyinstaller-versionfile
, tableauserverclient
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "tabcmd";
  version = "2.0.12";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nsQJWDzSzSc1WRk5TBl/E7Mpfk8wGD1CsETAWILKxCM=";
  };

  propagatedBuildInputs = [ ftfy appdirs requests setuptools-scm types-mock types-appdirs argparse doit pyinstaller-versionfile types-requests types-setuptools tableauserverclient ];

  nativeCheckInputs = [ pytestCheckHook mock ];

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


  meta = {
    description = "A command line client for working with Tableau Server.";
    homepage = "https://pypi.org/project/tabcmd/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
