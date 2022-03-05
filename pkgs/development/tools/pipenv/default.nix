{ lib
, python3
, installShellFiles
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
  version = "2022.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f84d7119239b22ab2ac2b8fbc7d619d83cf41135206d72a17c4f151cda529fd0";
  };

  LC_ALL = "en_US.UTF-8";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    # pipenv invokes python in a subprocess to create a virtualenv
    # and to call setup.py.
    # It would use sys.executable, which in our case points to a python that
    # does not have the required dependencies.
    substituteInPlace pipenv/core.py \
      --replace "sys.executable" "'${pythonEnv.interpreter}'"
  '';

  propagatedBuildInputs = runtimeDeps python3.pkgs;

  postInstall = ''
    installShellCompletion --cmd pipenv \
      --bash <(_PIPENV_COMPLETE=bash_source $out/bin/pipenv) \
      --zsh <(_PIPENV_COMPLETE=zsh_source $out/bin/pipenv) \
      --fish <(_PIPENV_COMPLETE=fish_source $out/bin/pipenv)
  '';

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
