{ lib
, python3
}:

with python3.pkgs;

let

  runtimeDeps = ps: with ps; [
    certifi
    setuptools
    pip
    virtualenv
    virtualenv-clone
  ];

  pythonEnv = python3.withPackages runtimeDeps;

in buildPythonApplication rec {
  pname = "pipenv";
  version = "2020.11.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6ac39d1721517b23aca12cdb4c726dc318ec4d7bdede5c1220bbb81775005c3";
  };

  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    # pipenv invokes python in a subprocess to create a virtualenv
    # and to call setup.py.
    # It would use sys.executable, which in our case points to a python that
    # does not have the required dependencies.
    substituteInPlace pipenv/core.py \
      --replace "sys.executable" "'${pythonEnv.interpreter}'"
  '';

  propagatedBuildInputs = runtimeDeps python3.pkgs;

  doCheck = true;
  checkPhase = ''
    export HOME=$(mktemp -d)
    cp -r --no-preserve=mode ${wheel.src} $HOME/wheel-src
    $out/bin/pipenv install $HOME/wheel-src
  '';

  meta = with lib; {
    description = "Python Development Workflow for Humans";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ berdario ];
  };
}
