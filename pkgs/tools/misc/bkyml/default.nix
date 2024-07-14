{ lib
, python3
, fetchPypi
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "bkyml";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KZ8lJ1YzJGTOdHFV/z2T7jmZxnTbSydoJ7eKU8rodwY=";
  };

  # The pyscaffold is not a runtime dependency but just a python project bootstrapping tool. Thus,
  # instead of implement this package in nix we remove a dependency on it and fix up the version
  # of the package, that has been affected by the pyscaffold package dependency removal.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "['pyscaffold>=3.0a0,<3.1a0'] + " "" \
      --replace "use_pyscaffold=True"  ""
    substituteInPlace src/bkyml/skeleton.py --replace \
        "from bkyml import __version__" \
        "__version__ = \"${version}\""
  '';

  # Don't run tests because they are broken when run within
  # buildPythonApplication for reasons I don't quite understand.
  doCheck = false;

  pythonImportsCheck = [ "bkyml" ];

  propagatedBuildInputs = [
    ruamel-yaml
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/joscha/bkyml";
    description = "CLI tool to generate a pipeline.yaml file for Buildkite on the fly";
    license = licenses.mit;
    maintainers = with maintainers; [ olebedev ];
  };
}
