{ lib
, python3
}:

with python3.pkgs;

let

  runtimeDeps = [
    certifi
    setuptools
    pip
    virtualenv
    virtualenv-clone
  ];

  pythonEnv = python3.withPackages(ps: with ps; runtimeDeps);

in buildPythonApplication rec {
  pname = "pipenv";
  version = "2020.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12s7c3f3k5v1szdhklsxwisf9v3dk4mb9fh7762afpgs8mrrmm3x";
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

  propagatedBuildInputs = runtimeDeps;

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
