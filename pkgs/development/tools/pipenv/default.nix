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
  version = "2021.11.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bde859e8bbd1d21d503fd995bc0170048d6da7686ab885f074592c99a16e8f3";
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

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    _PIPENV_COMPLETE=bash_source "$out/bin/pipenv" > "$out/share/bash-completion/completions/pipenv"

    mkdir -p "$out/share/zsh/vendor-completions"
    _PIPENV_COMPLETE=zsh_source "$out/bin/pipenv" > "$out/share/zsh/vendor-completions/_pipenv"

    mkdir -p "$out/share/fish/vendor_completions.d"
    _PIPENV_COMPLETE=fish_source "$out/bin/pipenv" > "$out/share/fish/vendor_completions.d/pipenv.fish"
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
