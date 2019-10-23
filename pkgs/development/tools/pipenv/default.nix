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

  pythonEnv = python3.withPackages(ps: with ps; [ virtualenv ]);

in buildPythonApplication rec {
  pname = "pipenv";
  version = "2018.11.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ip8zsrwmhrankrix0shig9g8q2knmr7b63sh7lqa8a5x03fcwx6";
  };

  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    # pipenv invokes python in a subprocess to create a virtualenv
    # it uses sys.executable which will point in our case to a python that
    # does not have virtualenv.
    substituteInPlace pipenv/core.py \
      --replace "vistir.compat.Path(sys.executable).absolute().as_posix()" "vistir.compat.Path('${pythonEnv.interpreter}').absolute().as_posix()"
  '';

  nativeBuildInputs = [ invoke parver ];

  propagatedBuildInputs = runtimeDeps;

  doCheck = false;

  meta = with lib; {
    description = "Python Development Workflow for Humans";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ berdario ];
  };
}
